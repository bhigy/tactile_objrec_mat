function selection = randomSelection(m, n)
    % Returns a vector of size n, with m '1' choosen randomly and 
    % everything else being '0'
    
    if (m > n)
        error('Invalid arguments (m > n)'); 
    end
    
    selection = zeros(n, 1);
    i_available = 1:n;
    for i = n:-1:(n - m + 1)
        r = ceil(rand()*i);
        selection(i_available(r)) = 1;
        i_available(r) = [];
    end
    selection = logical(selection);
end