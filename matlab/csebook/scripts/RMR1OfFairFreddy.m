function y = RMR1OfFairFreddy(x,w)
% Random Mapping Representation Number 1 of P=[1/2 1/2; 1/2 12/]
% input: character x as 'r' or 'f' and w as 0 or 1
% output: character y as 'r' or 'f'
if (x =='r')
    if (w==0)
        y = 'r';
    elseif (w==1)
        y = 'f';
    else
        y = Nan;
        print "when x = 'r' w is neither 0 nor 1!";
    end
elseif (x =='f')
    if (w==0)
        y = 'f';
    elseif (w==1)
        y = 'r';
    else
        y = Nan;
        print "when x='f' w is neither 0 nor 1!";
    end
else
    y = Nan;
    print "x is neither 'r' nor 'f'";
end

