function z = getZ8(formula,k,n)

if strcmp(formula,'True') || strcmp(formula,' True')
    z = 1;
    return
end

global Z2;

if isnumeric(formula)
    formula = strcat('[ ', num2str(formula), ']');       
end

formula = num2str(formula);

i = find(strcmp([Z2{:}],formula));


if isempty(i)                              
    %create new sdpvar if not created before
    z = binvar(k,n,'full');             
    Z2{length(Z2)+1} = {z,formula};        
else
    % else return the existing one
    z = Z2{i/2}{1};                        
end
