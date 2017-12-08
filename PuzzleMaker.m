function PuzzleMaker(src)
   %% load and crop image
    imdata = imread(src);
    imdata = rgb2gray(imdata);
    new_dims = size(imdata) - rem(size(imdata), 3);
    imdata = imdata(1:new_dims(1),1:new_dims(2));
    %% Arrange into 3x3 cell
    block_dims = new_dims./[3 3];
    blocks = mat2cell(imdata, block_dims(1)*ones(3,1), block_dims(2)*ones(3,1));
    %% Rearrange randomly
    blocks(1:9) = blocks(randperm(9));
    %% Return to image
    puzzle = cell2mat(blocks);
    %% Plot input and output
    figure(1)
    imshow(imdata)
    figure(2)
    imshow(puzzle)
    
    child = [1:9];
    %%표본 만들기
    for i = 1:100
        child(1:9) = child(randperm(9));
        children(i,:) = child;
    end
    
    for i = 1:100
       children_local = mat2cell(imdata, block_dims(1)*ones(3,1), block_dims(2)*ones(3,1));
       children_local(1:9) = children_local(children(i,:));
       
       for j = 1:9
           parts(j,:,:) = cell2mat(children_local(j));
       end
       parts = double(parts);
       for j = 1:9
           if rem(j,3) == 1
                check = parts(j,:,end) - parts(j+3,:,end);
                check = parts(j,:,end) - parts(j+1,:,end);
           end
           if rem(j,3) == 2
                check = parts(j,:,end) - parts(j+3,:,end);
                check = parts(j,:,end) - parts(j+1,:,end);
           end
           if rem(j,3) == 0
                check = parts(j,:,end) - parts(j+3,:,end);
           end
       end
    end
end