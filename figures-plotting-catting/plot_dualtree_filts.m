faf1 = Faf{1};
faf2 = Faf{2};
af1 = af{1};
af2 = af{2};
fsf1 = Fsf{1};
fsf2 = Fsf{2};
sf1 = sf{1};
sf2 = sf{2};


figure(); subplot(4, 2, 1); plot([faf1(:,1), faf2(:,1)]); title('Faf Lo');
subplot(4, 2, 2); plot([faf1(:,2), faf2(:,2)]); title('Faf Hi');
subplot(4, 2, 3); plot([af1(:,1), af2(:,1)]); title('Af Lo');
subplot(4, 2, 4); plot([af1(:,2), af2(:,2)]); title('Af Hi');
subplot(4, 2, 5); plot([fsf1(:,1), fsf2(:,1)]); title('Fsf Hi');
subplot(4, 2, 6); plot([fsf1(:,2), fsf2(:,2)]); title('Fsf Lo');
subplot(4, 2, 7); plot([sf1(:,1), sf2(:,1)]); title('Sf Hi');
subplot(4, 2, 8); plot([sf1(:,2), sf2(:,2)]); title('Sf Lo');



