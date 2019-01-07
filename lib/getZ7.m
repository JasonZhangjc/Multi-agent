function z = getZ7(formula,k,n)

if strcmp(formula,'True') || strcmp(formula,' True')
    z = 1;
    return
end

global Z1;

if isnumeric(formula)
    formula = strcat('[ ', num2str(formula), ']');       
end

formula = num2str(formula);


i = find(strcmp([Z1{:}],formula));

if isempty(i)                              
    z = binvar(k,n,'full');                
    Z1{length(Z1)+1} = {z,formula};          
else
    % else return the existing one
    z = Z1{i/2}{1};                        
end
