function temple_abm_economy_stock_market
%TEMPLE_ABM_ECONOMY_STOCK_MARKET
%   Agents participating in a stock market. Each
%   agent holds a number of shares and possesses
%   a certain amount of cash. Moreover, each agent
%   has a personal maximum buying price and a
%   minimum selling price for a share. Each step
%   consists of (A) market adjustment, and
%   (B) agent price adjustment. In part (A), the
%   stock price goes up or down until there are
%   buyers and sellers in the market. Once there
%   are, trading of shares happens until the market
%   is in equilibrium. Part (B) consists of random
%   fluctuations of agents' prices, plus a momentum
%   effect, depending on the direction of the
%   stock price.
%
% 04/2016 by Benjamin Seibold (original)
% 04/2018 by Benjamin Seibold (latest version)
%            http://www.math.temple.edu/~seibold/

%------------------------------------------------------------------------
% Parameters
%------------------------------------------------------------------------
n = 10; % number of agents (each agent can sell and buy
number_of_shares_total = 50*n; % number of shares of stock in the market
stock_price = 50; % initial price per share
max_price = stock_price*2; % initial maximum price per share

% Initialization
max_buying_price = randi(stock_price,1,n);
min_selling_price = randi(max_price-stock_price,1,n)+stock_price;
number_of_shares = ones(1,n)*floor(number_of_shares_total/n);
number_of_shares(1) = number_of_shares_total-sum(number_of_shares(2:end));
max_shares = max(number_of_shares); % initial max number of shares
cash = number_of_shares*stock_price; % initial value of cash per agent
max_cash = max(cash); % initial maximum cash per agent

% Computation
for i = 1:10000 % time loop
    %--------------------------------------------------------------------
    % Plotting
    %--------------------------------------------------------------------
    clf
    subplot(3,1,1)
    % Plot market prices
    buy_price = max(max_buying_price(cash>=stock_price));
    sell_price = min(min_selling_price(number_of_shares>0));
    patch([0 0 1 1]*(n+2),buy_price+[1 -1 -1 1],...
        [0 .8 0],'EdgeColor','none')
    patch([0 0 1 1]*(n+2),sell_price+[1 -1 -1 1],...
        [1 0 0],'EdgeColor','none')
    patch([0 0 1 1]*(n+2),stock_price+[1 -1 -1 1]*.5,[0 0 0])
    for j = 1:n % loop over agents
        % Bars for maximum buying price
        c = sign(max_buying_price(j)-stock_price);
        col = [0 .8 0]*(.7+(c>=0)*.3); % color of bar
        if cash(j)<stock_price, col = [1 1 1]; end % cannot afford buying
        patch(j-.4+[0 1 1 0]*.4,[0 0 1 1]*max_buying_price(j),col)
        text(j-.2,max_buying_price(j)/2,'buy for',...
            'HorizontalAlign','center','Rotation',90)
        % Bars for minimum selling price
        c = sign(min_selling_price(j)-stock_price);
        col = [1 0 0]*(.7+(c<=0)*.3); % color of bar
        if number_of_shares(j)==0, col = [1 1 1]; end % no shares held
        patch(j+[0 1 1 0]*.4,[0 0 1 1]*min_selling_price(j),col)
        text(j+.2,min_selling_price(j)/2,'sell for',...
            'HorizontalAlign','center','Rotation',90)
    end
    max_price = max([max_price,min_selling_price,max_buying_price]);
    text(n+.5,buy_price,'max buying price',...
        'VerticalAlign','top','Color',[0 .4 0])
    text(n+.5,sell_price,'min selling price',...
        'VerticalAlign','bottom','Color',[.5 0 0])
    axis([0,n+2,0,max_price*1.1])
    title('Prices')
    
    subplot(3,1,2)
    for j = 1:n % loop over agents
        % Bars for number of shares
        patch(j-.4+[0 1 1 0]*.8,[0 0 1 1]*number_of_shares(j),[0 0 1])
    end
    max_shares = max([max_shares,number_of_shares]);
    axis([0,n+2,0,max_shares*1.1])
    title('Number of shares per agent')
    
    subplot(3,1,3)
    net_worth = cash+number_of_shares*stock_price; % net worth of agents
    for j = 1:n % loop over agents
        % Bars for cash available
        patch(j-.4+[0 1 1 0]*.4,[0 0 1 1]*cash(j),...
            [.85 .9 0]*(.5+.5*(cash(j)>=stock_price)))
        text(j-.2,cash(j)/2,'cash available',...
            'HorizontalAlign','center','Rotation',90)
        % Bars for net worth
        patch(j+[0 1 1 0]*.4,[0 0 1 1]*net_worth(j),[.95 .8 0])
        text(j+.2,net_worth(j)/2,'net worth',...
            'HorizontalAlign','center','Rotation',90)
    end
    max_cash = max([max_cash,cash,net_worth]);
    axis([0,n+2,0,max_cash*1.1])
    title('Cash and net worth')
    pause(1e-2)
    
    %--------------------------------------------------------------------
    % Update rule
    %--------------------------------------------------------------------
    % Conduct stock trades (when possible) and stock price adjustments
    starting_price = stock_price; % stock price before market
    while 1 % loop until market equilibrium is reached
        buy_price = max(max_buying_price(cash>=stock_price));
        sell_price = min(min_selling_price(number_of_shares>0));
        if buy_price<sell_price&&... % if no trades possible at any price
                buy_price<=stock_price&&sell_price>=stock_price % and
            break % stock price adjusted, terminate
        end
        % Determine potential buyers and sellers
        ind_willing_to_buy = find(stock_price<=max_buying_price&...
            cash>=stock_price); % wants to and can buy
        ind_willing_to_sell = find(stock_price>=min_selling_price&...
            number_of_shares>0); % wants to and can sell
        n_willing_to_buy = numel(ind_willing_to_buy); % number or buyers
        n_willing_to_sell = numel(ind_willing_to_sell); % nr of sellers
        if n_willing_to_buy&&n_willing_to_sell % if a trade possible
            % Randomly determine a buyer and a seller
            ind_buying = ind_willing_to_buy(randi(n_willing_to_buy));
            ind_selling = ind_willing_to_sell(randi(n_willing_to_sell));
            % Conduct the trade, moving a share
            number_of_shares(ind_buying) = ...
                number_of_shares(ind_buying)+1;
            number_of_shares(ind_selling) = ...
                number_of_shares(ind_selling)-1;
            cash(ind_buying) = cash(ind_buying)-stock_price;
            cash(ind_selling) = cash(ind_selling)+stock_price;
            % Adjust individual prices of recent traders
            max_buying_price(ind_buying) = ...
                max(max_buying_price(ind_buying)-1,0);
            min_selling_price(ind_selling) = ...
                min_selling_price(ind_selling)+1;
        elseif n_willing_to_buy&&~n_willing_to_sell % demand but no supply
            stock_price = stock_price+1; % increase stock price
        elseif ~n_willing_to_buy&&n_willing_to_sell % supply but no demand
            stock_price = max(stock_price-1,1); % lower stock price
        else % if no demand and no supply
            break % terminate
        end
    end
    
    % Random fluctuation in agents' buying and selling prices
    max_buying_price = max_buying_price+randi(3,1,n)-2;
    min_selling_price = min_selling_price+randi(3,1,n)-2;
    
    % Introduce momentum
    change = stock_price-starting_price; % stock price change
    max_buying_price = max_buying_price+... % move agents' buying prices
        round(3*max(change,0)*rand(1,n).*... % up if stock price goes up
        (cash>=stock_price));
    min_selling_price = min_selling_price+... % move selling prices down
        round(3*min(change,0)*rand(1,n).*... % if stock price goes down
        (number_of_shares>0));
    min_selling_price = max(min_selling_price,1);
    
    % Make buying prices >=0 and selling prices > buying prices
    max_buying_price = max(max_buying_price,0);
    ind = max_buying_price>min_selling_price; % unbalanced prices
    avg_price = (max_buying_price+min_selling_price)/2; % use average price
    max_buying_price(ind) = round(avg_price(ind)-.5);
    min_selling_price(ind) = max_buying_price(ind)+1;
end
