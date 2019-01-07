function [fF,phiF] = getF7(formula, args, k)

global Mw Z zLoop ZLoop bigM epsilon W1 Z1;


if length(args)~=1
    disp('F(eventually) takes a single argument')
    assert(length(args)==1)
end


if k < length(Mw)

    % phi2 
    [fF,phi2] = getLTL7(args{1},k);
    
    % F[[phi2]]_i+1
    [fU2,phiF2] = getF7(formula, args, k+1);
    fF = [fF, fU2];

    % phiF_k = Or(phi2_k,phiF_k+1)
    phiF = getZ7(formula,k,1);
    fF = [fF, phiF>=phi2, phiF>=phiF2, phiF<=phiF2+phi2];
    
else

    % phi1
    phi1 = 1;
    
    % phi2 
    [fF,phi2] = getLTL7(args{1},k);
    
    % za = << phi1 U phi2 >>
    za = [];
    
    % zb_i = And(zLoop_i,za_i)
    zb = [];
    
    % bigOr in (15)
    formulaOr = 'Or(';
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
       fF = [fF, zb(i)<=za(i), zb(i)<=zLoop(i), zb(i)>=za(i)+zLoop(i)-1];
       
       formulaOr = strcat(formulaOr, formulaAnd, ',');
    
    end
    formulaOr = strcat(formulaOr,')');
    % bigOr, see eq (15) in paper
    zOr = getZ7(formulaOr,1,1);
    fF = [fF, zOr<=sum(zb), repmat(zOr,k,1)>=zb];
    
    % finally (15)
    phiF = getZ7(formula,k,1);
    fF = [fF, phiF<=zOr+phi2, phiF>=phi2, phiF>=zOr];
    
    % aux variables see (16)
    for i=1:k-1
        
        phi2_i = getZ7(args{1},i,1);
        fF = [fF, za(i)<=za(i+1)+phi2_i, za(i)>=phi2_i, za(i)>=za(i+1)];
        
    end

    % Last step
    phi2_k = getZ7(args{1},k,1);
    fF = [fF, za(k)==phi2_k];
    
end
    