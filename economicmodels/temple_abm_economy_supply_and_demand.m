function temple_abm_economy_supply_and_demand
%TEMPLE_ABM_ECONOMY_SUPPLY_AND_DEMAND
%   Two types of agents interact with each other:
%   producers of goods who sell them, and consumers
%   of good who buy them. Each agent possesses a
%   certain number of goods. Each seller has a
%   personal minimum selling price, and each buyer
%   has a personal maximum buying price. There is
%   a market price, and buyers/sellers become
%   active if the market price is above/below or
%   equal their personal price. In each step a
%   certain number of trades are performed between
%   willing sellers and buyers. In addition, the
%   market price moves up/down depending on
%   whether the number of willing buyers/sellers
%   is larger. This model shows how market price
%   fluctuations arise, and it also shows how the
%   long-term market price blows up/plummets if
%   there is am imbalance between production and
%   consumption.
%
% 04/2016 by Benjamin Seibold
%            http://www.math.temple.edu/~seibold/

%------------------------------------------------------------------------
% Parameters
%------------------------------------------------------------------------
n = [15,15]; % number of agents (sellers and buyers)
desired_stock = 50; % desired number of goods
max_stock = 100; % maximum possible stock (all above goes to waste)
market_price = 50; % initial market price
max_number_of_trades = 2*max(n); % maximum number of trades per turn
production = 1; % number of goods added to each seller per turn
consumption = 1; % number of goods taken away from each buyer per turn

% Initialization
min_selling_price = randi(market_price*2,1,n(1));
max_buying_price = randi(market_price*2,1,n(2));
number_of_goods_seller = ones(1,n(1))*desired_stock;
number_of_goods_buyer = ones(1,n(2))*desired_stock;
max_price = 0;
if max_stock==inf, max_goods = 0; else max_goods = max_stock; end

% Computation
for i = 1:10000 % time loop
    %--------------------------------------------------------------------
    % Plotting
    %--------------------------------------------------------------------
    clf
    subplot(2,1,1)
    % Plot current market price
    patch([-[1 1]*(n(1)+1),[1 1]*(n(2)+1)],...
        market_price+[1 -1 -1 1],[0 0 0])
    for j = 1:n(1) % loop over sellers
        % Bars for minimum selling price
        c = sign(min_selling_price(j)-market_price);
        patch(j-n(1)-1.4+[0 1 1 0]*.8,...
            [0 0 1 1]*min_selling_price(j),...
            [c>0 (c<0)*.8 c==0])
    end
    for j = 1:n(2) % loop over buyers
        % Bars for maximum buying price
        c = sign(max_buying_price(j)-market_price);
        patch(j-.4+[0 1 1 0]*.8,...
            [0 0 1 1]*max_buying_price(j),...
            [c<0 (c>0)*.8 c==0])
    end
    max_price = max([max_price,min_selling_price,max_buying_price]);
    patch([-1 -1 1 1]*.1,[1 0 0 1]*max_price*1.1,[0 0 0]) % vertical bar
    text(-n(1)/2,max_price*1.1,'producers / sellers',...
        'HorizontalAlign','center')
    text(n(2)/2,max_price*1.1,'consumers / buyers',...
        'HorizontalAlign','center')
    text(n(2)+.5,market_price,'market price',...
        'HorizontalAlign','right','VerticalAlign','bottom')
    axis([-n(1)-.5,n(2)+.5,0,max_price*1.1])
    title('Prices')
    subplot(2,1,2)
    % Plot desired stock and maximum stock
    patch([-[1 1]*(n(1)+1),[1 1]*(n(2)+1)],...
        desired_stock+[1 -1 -1 1],[0 0 0])
    if max_stock<inf
        patch([-[1 1]*(n(1)+1),[1 1]*(n(2)+1)],...
            max_stock+[1 -1 -1 1],[0 0 0])
    end
    for j = 1:n(1) % loop over sellers
        % Bars for number of goods
        c = sign(number_of_goods_seller(j)-desired_stock);
        patch(j-n(1)-1.4+[0 1 1 0]*.8,...
            [0 0 1 1]*number_of_goods_seller(j),...
            [c>0 (c<0)*.8 c==0])
    end
    for j = 1:n(2) % loop over buyers
        % Bars for number of goods
        c = sign(number_of_goods_buyer(j)-desired_stock);
        patch(j-.4+[0 1 1 0]*.8,...
            [0 0 1 1]*number_of_goods_buyer(j),...
            [c>0 (c<0)*.8 c==0])
    end
    max_goods = max([max_goods,...
        number_of_goods_seller,number_of_goods_buyer]);
    patch([-1 -1 1 1]*.1,[1 0 0 1]*max_goods*1.1,[0 0 0]) % vertical bar
    text(-n(1)/2,max_goods*1.1,'producers / sellers',...
        'HorizontalAlign','center')
    text(n(2)/2,max_goods*1.1,'consumers / buyers',...
        'HorizontalAlign','center')
    text(n(2)+.5,max_stock,'maximum stock',...
        'HorizontalAlign','right','VerticalAlign','bottom')
    text(n(2)+.5,desired_stock,'desired stock',...
        'HorizontalAlign','right','VerticalAlign','bottom')
    axis([-n(1)-.5,n(2)+.5,0,max_goods*1.1])
    title('Number of goods')
    pause(1e-2)
    
    %--------------------------------------------------------------------
    % Update rule
    %--------------------------------------------------------------------
    for j = 1:max_number_of_trades % loop over allowed number of trades
        % Determine potential buyers and sellers
        ind_willing_to_sell = find(market_price>=min_selling_price&...
            number_of_goods_seller>0); % wants to and can sell
        ind_willing_to_buy = find(market_price<=max_buying_price&...
            number_of_goods_buyer<max_stock); % wants to and can buy
        n_willing_to_sell = numel(ind_willing_to_sell); % # of sellers
        n_willing_to_buy = numel(ind_willing_to_buy); % number or buyers

        % Change market price up/down if more/less buyers than sellers
        market_price = max(market_price+...
            sign(n_willing_to_buy-n_willing_to_sell),1);

        % Trading
        if n_willing_to_sell&&n_willing_to_buy % if a trade possible
            % Randomly determine a seller and a buyer
            ind_selling = ind_willing_to_sell(randi(n_willing_to_sell));
            ind_buying = ind_willing_to_buy(randi(n_willing_to_buy));
            % Conduct the trade, move a piece of goods
            number_of_goods_seller(ind_selling) = ...
                number_of_goods_seller(ind_selling)-1;
            number_of_goods_buyer(ind_buying) = ...
                number_of_goods_buyer(ind_buying)+1;
        else
            break
        end
    end
    
    % Adjust individual selling and buying prices based on ownership
    % Producers/sellers
    min_selling_price = ... % sellers raise/lower their prices
        max(min_selling_price-... % when they have too much/little goods
        sign(number_of_goods_seller-desired_stock),1); % in stock
    ind_waste = number_of_goods_seller>=max_stock; % producers with waste
    min_selling_price(ind_waste) = max(... % lower their price
        min_selling_price(ind_waste)-10,1); % substantially
    % Consumers/buyers
    max_buying_price = ... % buyers lower/raise what they are willing to
        max(max_buying_price-... % pay when they have too much/little
        sign(number_of_goods_buyer-desired_stock),0); % goods in stock
    
    % Adjust goods ownership by production and consumption
    number_of_goods_seller = ... % production of goods (cannot exceed
        min(number_of_goods_seller+production,max_stock); % maximum stock)
    number_of_goods_buyer = ... % comsumption of goods (cannot fall
        max(number_of_goods_buyer-consumption,0); % below zero)
end
