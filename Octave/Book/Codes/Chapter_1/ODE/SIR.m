function res = SIR(t,I,R,b,k) %%x = IR
res = [(+b-k-b*I-b*R).*I;  k*I];
end%function