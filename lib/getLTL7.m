function [fLTL,phi] = getLTL7(formula,k)               

global W Wtotal Z1 Z2 zLoop ZLoop bigM epsilon tau NW NM W1;

[Op,args] = parseLTL7(formula);                        


switch Op                                             
    case 'And'
        [fLTL,phi] = getAnd7(formula,args,k);           
    case 'Or'
        [fLTL,phi] = getOr7(formula,args,k);
    case 'Neg'
        [fLTL,phi] = getNeg7(formula,args,k);
    case 'AndI'
        [fLTL,phi] = getAndI7(formula,args,k);
    case 'OrI'
        [fLTL,phi] = getOrI(formula,args,k);
    case 'NegI'
        [fLTL,phi] = getNegI(formula,args,k);
    case 'G'											
        [fLTL,phi] = getG7(formula,args,k);
    case 'F'											
        [fLTL,phi] = getF7(formula,args,k);
    case 'X'                                            
        [fLTL,phi] = getX7(formula,args,k);
    case 'U'                     						
        [fLTL,phi] = getU7(formula,args,k);
    case 'GG'											
        [fLTL,phi] = getGG7(formula,args,k);
    case 'FF'											
        [fLTL,phi] = getFF7(formula,args,k);
    case 'FG'										
        [fLTL,phi] = getFG7(formula,args,k);
    case 'GF'										
        [fLTL,phi] = getGF7(formula,args,k);
    case 'GGI'
        [fLTL,phi] = getGGI(formula,args,k);
    case 'FFI'
        [fLTL,phi] = getFFI(formula,args,k);
    case 'FGI'
        [fLTL,phi] = getFGI(formula,args,k);
    case 'GFI'
        [fLTL,phi] = getGFI7(formula,args,k);
    case 'TP'                         					
        [fLTL,phi] = getTPTau7(formula,args,k);
    case 'AXB'
        [fLTL,phi] = getAXB(formula,args,k);
    case 'FFAB'
        [fLTL,phi] = getFFAB(formula,args,k);
    case 'GFIAB'
        [fLTL,phi] = getGFIAB(formula,args,k);
    case 'TPB'                         					
        [fLTL,phi] = getTPTau8(formula,args,k);
    case 'AUB'                         					
        [fLTL,phi] = getAUB(formula,args,k);
    otherwise
        disp('wrong formula');
end
    
