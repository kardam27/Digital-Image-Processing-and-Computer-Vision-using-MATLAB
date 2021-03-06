image1=imread('pic.jpg'); %original pic
image2=imread('croppedpic.jpg'); %cropped pic
x=im2bw(image1);
y=im2bw(image2);
z=detectSURFFeatures(x);
z1=detectSURFFeatures(y);
plot(z.selectStrongest(1000))
figure;
hold on;
plot(z1.selectStrongest(1000))
figure;
hold on;
[v,z]=extractFeatures(x,z);
[b,z1]=extractFeatures(y,z1);
n=matchFeatures(v,b);
image3=z(n(:,1));   %Eliminates all features except the matched one in the original image
image4=z1(n(:,2));  %Again does the same ,necessary because other features other than the cropped image are also matched in the original image,see the connecting lines
figure;
showMatchedFeatures(x,y,image3,image4)
[tform,s1,s2]=estimateGeometricTransform(image3,image4,'affine');
figure;
showMatchedFeatures(image1,image2,s1,s2)
k=[1,1;size(image2,2),1;size(image2,2),size(image2,1);1,size(image2,1);1,1];
f=transformPointsForward(tform,k);
figure;
imshow(image1)
hold on
line(f(:,1),f(:,2),'color','R');

