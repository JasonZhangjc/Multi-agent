function [fLTL,phi] = getLTL8(formula,k)               

% getLTL8 ��Ϊ�� NM
% Ҳ���Ǻ�����agents����ģ�������������������������������������������������������������������������������������������������

global W Wtotal Z1 Z2 zLoop ZLoop bigM2 epsilon tau NM NW W2 W1;

[Op,args] = parseLTL8(formula);                        


switch Op                                               % 有这么多种�?辑符�?
    case 'And'
        [fLTL,phi] = getAnd8(formula,args,k);            % 在这里调用下去的 k 应该也是 1 才对�?
    case 'Or'
        [fLTL,phi] = getOr8(formula,args,k);
    case 'Neg'
        [fLTL,phi] = getNeg8(formula,args,k);
    case 'AndI'
        [fLTL,phi] = getAndI8(formula,args,k);
    case 'OrI'
        [fLTL,phi] = getOrI(formula,args,k);
    case 'NegI'
        [fLTL,phi] = getNegI(formula,args,k);
    case 'G'											% G 是always
        [fLTL,phi] = getG8(formula,args,k);
    case 'F'											% F 是eventually
        [fLTL,phi] = getF(formula,args,k);
    case 'X'                                            % X 对应的是next
        [fLTL,phi] = getX8(formula,args,k);
    case 'U'                     						% U 对应的是until
        [fLTL,phi] = getU8(formula,args,k);
    case 'GG'											% GG 是always吗？？？？？？？？？�?
        [fLTL,phi] = getGG8(formula,args,k);
    case 'FF'											% FF 是eventually？？？？？？？？？？�?
        [fLTL,phi] = getFF8(formula,args,k);
    case 'FG'											% FG 是eventually-always
        [fLTL,phi] = getFG8(formula,args,k);
    case 'GF'											% GF 是always-eventually
        [fLTL,phi] = getGF8(formula,args,k);
    case 'GGI'
        [fLTL,phi] = getGGI(formula,args,k);
    case 'FFI'
        [fLTL,phi] = getFFI(formula,args,k);
    case 'FGI'
        [fLTL,phi] = getFGI(formula,args,k);
    case 'GFI'
        [fLTL,phi] = getGFI8(formula,args,k);
    case 'TP'                         					% TP 是带有counting �?cLTL
        [fLTL,phi] = getTPTau8(formula,args,k);
    case 'BXA'
        [fLTL,phi] = getBXA(formula,args,k);
    case 'GFIBA'
        [fLTL,phi] = getGFIBA(formula,args,k);
    case 'TPA'                         					% TP 是带有counting �?cLTL
        [fLTL,phi] = getTPTau7(formula,args,k);
    otherwise
        disp('wrong formula');
end
    
