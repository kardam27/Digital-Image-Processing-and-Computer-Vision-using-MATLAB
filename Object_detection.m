thresh=0.1;
sample=imaq.VideoDevice('winvideo', 1,'YUY2_320x240','ROI',[1 1 320 240],'ReturnedColorSpace','rgb'); %Input from the webcam
videoinfo=imaqhwinfo(sample);
hblob=vision.BlobAnalysis('AreaOutputPort',false,'CentroidOutputPort',true,'BoundingBoxOutputPort',true,'MinimumBlobArea',50,'MaximumBlobArea',3000,'MaximumCount',10);
htext=vision.ShapeInserter('BorderColor','Custom','CustomBorderColor',[0 1 0],'Fill',true,'FillColor','Custom','CustomFillColor',[0 1 0],'Opacity',0.4);
hshape=vision.TextInserter('Text','green:%2d','Location',[5 2],'Color',[0 1 0],'Font','Arial','FontSize',16);
hcoordinates=vision.TextInserter('Text','+x:%4d,y:%4d','LocationSource','Input Port'  #giveposition of x and y coordinates#,'Color',[1 0 0],'Font','Arial','FontSize',16);
hplay=vision.VideoPlayer('Name','Color Detection','Position',[300 300 videoinfo.MaxWidth+30 videoinfo.MaxHeight+30]);
n=0;
while (n<1000)
    frame=step(sample);
    frame=flipdim(frame,2);
    a=imsubtract(frame(:,:,2),rgb2gray(frame));
    a=medfilt2(a,[3 3]);
    a1=im2bw(a,thresh);
    [centroidsample,bboxsample]=step(hblob,a1);
    centroidsample=uint16(centroidsample);
    vidinp=step(htext,frame,bboxsample);
    for (object=1:1:length(bboxsample):1) 
        centx=centroidsample(object,1);
        centy=centroidsample(object,1);
        vidinp=step(hcoordinates,vidinp,[centx centy],[centx-6 centy-9]);
    end
    vidinp=step(hshape,vidinp,[uint8(length(bboxsample(:,1)))]);
    step(hplay,vidinp);
    n=n+1;
end
release(hplay);
release(sample);    
