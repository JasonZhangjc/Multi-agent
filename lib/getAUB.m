function [fU,phiU] = getAUB(formula, args, k)

global Mw Z zLoop ZLoop bigM epsilon Z1 Z2 W1 W2 W;

% number of agents
N = length(W);
% number of states
I = size(W{1},1);
% time horizon
h = size(W{1},2)-1;


if length(args)~=2
    disp('U(until) takes a two argument')
    assert(length(args)==2)
end

% if k < length(Mw)
if k < h
    
    % phi1
    [fU,phi1] = getLTL7(args{1},k);
    
    % phi2 
    [f2,phi2] = getLTL8(args{2},k);
    fU = [fU, f2];
    
    % [[phi1 U phi2]]_i+1
    [fU2,phiU2] = getAUB(formula, args, k+1);
    fU = [fU, fU2];
    
    % And(phi1_k, [[phi1 U phi2]]_k+1)
    formulaAnd = strcat('And(', ...
        num2str(args{1}), '[',num2str(k),'],', ...
                 formula, '[',num2str(k+1),'])');
    zAnd = getZ7(formulaAnd,1,1);
    fU = [fU, zAnd<=phi1, zAnd<=phiU2, zAnd>=phiU2+phi1-1];
    
    % phiU_k = Or(phi2_k,zAnd)
    phiU = getZ7(formula,k,1);
%     phiU = getZ7(formula,1,1);
    fU = [fU, phiU>=phi2, phiU>=zAnd, phiU<=zAnd+phi2];
    
else

    % phi1
    [fU,phi1] = getLTL7(args{1},k);
    
    % phi2 
    [f2,phi2] = getLTL8(args{2},k);
    fU = [fU, f2];
    
    % za = << phi1 U phi2 >>
    za = [];
    
    % zb_i = And(zLoop_i,za_i)
    zb = [];
    
    % bigOr in (15)
    formulaOr = 'Or( ';
    for i=1:k
       % za_i = << phi1 U phi2 >>_i 
       za_i = getZ7(strcat('~',formula),i,1);
       za = [za;za_i];
       
       % zb_i = And(zLoop_i,za_i)
       formulaAnd = strcat('And(', ...
                    'zLoop', '[',num2str(i),'],', ...
        strcat('~',formula), '[',num2str(i),'])');
       zb_i = getZ7(formulaAnd,1,1);
       zb = [zb;zb_i];
       fU = [fU, zb(i)<=za(i), zb(i)<=zLoop(i), zb(i)>=za(i)+zLoop(i)-1];
       
       formulaOr = strcat(formulaOr, formulaAnd, ',');
    
    end
    formulaOr = strcat(formulaOr,')');
    % bigOr, see eq (15) in paper
    zOr = getZ7(formulaOr,1,1);
    fU = [fU, zOr<=sum(zb), repmat(zOr,k,1)>=zb];
    
    % second term in paranthesis (15)
    formulaAnd = strcat('And( ', ...
        num2str(args{1}), '[',num2str(k),'], ', ...
               formulaOr, '[-1]');
    zAnd = getZ7(formulaAnd,1,1);
    fU = [fU, zAnd<=zOr, zAnd<=phi1, zAnd>=phi1+zOr-1];
    
    % finally (15)
    phiU = getZ7(formula,k,1);
    fU = [fU, phiU<=zAnd+phi2, phiU>=phi2, phiU>=zAnd];
    
    % aux variables see (16)
    for i=1:k-1
       % second term in paranthesis (16)
       formulaAnd = strcat('And( ', ...
         num2str(args{1}), '[',num2str(i),'], ', ...
      strcat('~',formula), '[', num2str(i+1),'])'); 
  
       zAnd = getZ7(formulaAnd,1,1);
       phi1_i = getZ7(args{1},i,1);
       fU = [fU, zAnd<=za(i+1), zAnd<=phi1_i, zAnd>=za(i+1)+phi1_i-1];
       
        phi2_i = getZ8(args{2},i,1);
        fU = [fU, za(i)<=zAnd+phi2_i, za(i)>=phi2_i, za(i)>=zAnd];
        
    end

    % Last step
    phi2_k = getZ8(args{2},k,1);
    fU = [fU, za(k)==phi2_k];
    
end
    