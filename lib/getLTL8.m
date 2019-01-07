function [fLTL,phi] = getLTL8(formula,k)               

% getLTL8 是为了 NM
% 也就是后三个agents服务的！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！

global W Wtotal Z1 Z2 zLoop ZLoop bigM2 epsilon tau NM NW W2 W1;

[Op,args] = parseLTL8(formula);                        


switch Op                                               % 鏈夎繖涔堝绉嶉?杈戠鍙?
    case 'And'
        [fLTL,phi] = getAnd8(formula,args,k);            % 鍦ㄨ繖閲岃皟鐢ㄤ笅鍘荤殑 k 搴旇涔熸槸 1 鎵嶅銆?
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
    case 'G'											% G 鏄痑lways
        [fLTL,phi] = getG8(formula,args,k);
    case 'F'											% F 鏄痚ventually
        [fLTL,phi] = getF(formula,args,k);
    case 'X'                                            % X 瀵瑰簲鐨勬槸next
        [fLTL,phi] = getX8(formula,args,k);
    case 'U'                     						% U 瀵瑰簲鐨勬槸until
        [fLTL,phi] = getU8(formula,args,k);
    case 'GG'											% GG 鏄痑lways鍚楋紵锛燂紵锛燂紵锛燂紵锛燂紵锛?
        [fLTL,phi] = getGG8(formula,args,k);
    case 'FF'											% FF 鏄痚ventually锛燂紵锛燂紵锛燂紵锛燂紵锛燂紵锛?
        [fLTL,phi] = getFF8(formula,args,k);
    case 'FG'											% FG 鏄痚ventually-always
        [fLTL,phi] = getFG8(formula,args,k);
    case 'GF'											% GF 鏄痑lways-eventually
        [fLTL,phi] = getGF8(formula,args,k);
    case 'GGI'
        [fLTL,phi] = getGGI(formula,args,k);
    case 'FFI'
        [fLTL,phi] = getFFI(formula,args,k);
    case 'FGI'
        [fLTL,phi] = getFGI(formula,args,k);
    case 'GFI'
        [fLTL,phi] = getGFI8(formula,args,k);
    case 'TP'                         					% TP 鏄甫鏈塩ounting 鐨?cLTL
        [fLTL,phi] = getTPTau8(formula,args,k);
    case 'BXA'
        [fLTL,phi] = getBXA(formula,args,k);
    case 'GFIBA'
        [fLTL,phi] = getGFIBA(formula,args,k);
    case 'TPA'                         					% TP 鏄甫鏈塩ounting 鐨?cLTL
        [fLTL,phi] = getTPTau7(formula,args,k);
    otherwise
        disp('wrong formula');
end
    
