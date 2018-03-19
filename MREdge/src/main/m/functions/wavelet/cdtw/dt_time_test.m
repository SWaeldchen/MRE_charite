v = sinVec(1024, 256);
[Faf Fsf] = FSfarras;
[af sf] = dualfilt1;
a = now;
for n = 1:100
    w = idualtree(dualtree(v, 3, Faf, af), 3, Fsf, sf);
end
b = (now-a)*100000;
aa = now;
for n = 1:100
    ww = dt.inverse(dt.forward(v, 3), 3);
end
bb = (now-aa)*100000;
display('Elapsed Time');
display(['Matlab ', num2str(b),'s Java ',num2str(bb),'s']);
diff = w-ww';
display(['Max error: ', num2str(max(diff))]);
