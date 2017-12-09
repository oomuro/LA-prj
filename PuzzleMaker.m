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
       for j = 1:6
           if rem(j,3) == 1
                check = parts(j,:,end) - parts(j+3,:,1);
                checker(i,1) = sum(abs(check));
                check = parts(j,end,:) - parts(j+1,1,:);
                checker(i,1) = checker(i,1) + sum(abs(check));
           end
           if rem(j,3) == 2
                check = parts(j,:,end) - parts(j+3,:,1);
                checker(i,1) = checker(i,1) + sum(abs(check));
                check = parts(j,end,:) - parts(j+1,1,:);
                checker(i,1) = checker(i,1) + sum(abs(check));
           end
           if rem(j,3) == 0
                check = parts(j,:,end) - parts(j+3,:,1);
                checker(i,1) = checker(i,1) + sum(abs(check));
           end
       end
       for j = 7:9
           if rem(j,3) == 1
                check = parts(j,end,:) - parts(j+1,1,:);
                checker(i,1) = checker(i,1) + sum(abs(check));
           end
           if rem(j,3) == 2
                check = parts(j,end,:) - parts(j+1,1,:);
                checker(i,1) = checker(i,1) + sum(abs(check));
           end
       end
         [minNum num] = min(checker);
    end
    
    firstteach();
   [minNum num] = min(checker)
   clear checker;
    for k = 1:100
       ch = teaching(ch);   
       display(k)
    end
    [minNum num] = min(checker)
    for p = 1:5
        ch(p,:,:) = reshape(ch(p,:,:),3,3);
    end
    ch_result(:,:) = ch(1,:,:);
    ch_image = cell2mat(ch_result);
    imshow(ch_image)
    
    
    function firstteach()
    for i = 1:100
        children_local = mat2cell(imdata, block_dims(1)*ones(3,1), block_dims(2)*ones(3,1));
        children_local(1:9) = children_local(children(num,:));
        
        rand = randperm(9,2);
        
        temp = children_local(rand(1));
        children_local(rand(1)) = children_local(rand(2));
        children_local(rand(2)) = temp;
        
       for j = 1:9
           parts(j,:,:) = cell2mat(children_local(j));
       end
       
       parts = double(parts);
       for j = 1:6
           if rem(j,3) == 1
                check = parts(j,:,end) - parts(j+3,:,1);
                checker(i,1) = sum(abs(check));
                check = parts(j,end,:) - parts(j+1,1,:);
                checker(i,1) = checker(i,1) + sum(abs(check));
           end
           if rem(j,3) == 2
                check = parts(j,:,end) - parts(j+3,:,1);
                checker(i,1) = checker(i,1) + sum(abs(check));
                check = parts(j,end,:) - parts(j+1,1,:);
                checker(i,1) = checker(i,1) + sum(abs(check));
           end
           if rem(j,3) == 0
                check = parts(j,:,end) - parts(j+3,:,1);
                checker(i,1) = checker(i,1) + sum(abs(check));
           end
       end
       for j = 7:9
           if rem(j,3) == 1
                check = parts(j,end,:) - parts(j+1,1,:);
                checker(i,1) = checker(i,1) + sum(abs(check));
           end
           if rem(j,3) == 2
                check = parts(j,end,:) - parts(j+1,1,:);
                checker(i,1) = checker(i,1) + sum(abs(check));
           end
       end
       %%[minNum num] = min(checker);
       saveArray(i,:,:) = children_local;
    end
    checker_sort = sort(checker);
    for p = 1:5
       checker_find = find(checker(:,1)==checker_sort(p))';
       ch(p,:,:) = saveArray(checker_find(1,1),:,:);
    end
    %%ch = children_local(children(num,:));
    %%ch = reshape(ch,3,3);
    end

    function [ch] = teaching(ch)
    for p = 1:5
        for i = 1:10
        children_local(:,:) = ch(p,:,:);
        if i > 1
            rand = randperm(9,2);
            temp = children_local(rand(2));
            children_local(rand(2)) = children_local(rand(1));
            children_local(rand(1)) = temp;
        end
        
       for j = 1:9
           parts(j,:,:) = cell2mat(children_local(j));
       end
       
       parts = double(parts);
       for j = 1:6
           if rem(j,3) == 1
                check = parts(j,:,end) - parts(j+3,:,1);
                checker(i+(p-1)*10,1) = sum(abs(check));
                check = parts(j,end,:) - parts(j+1,1,:);
                checker(i+(p-1)*10,1) = checker(i+(p-1)*10,1) + sum(abs(check));
           end
           if rem(j,3) == 2
                check = parts(j,:,end) - parts(j+3,:,1);
                checker(i+(p-1)*10,1) = checker(i+(p-1)*10,1) + sum(abs(check));
                check = parts(j,end,:) - parts(j+1,1,:);
                checker(i+(p-1)*10,1) = checker(i+(p-1)*10,1) + sum(abs(check));
           end
           if rem(j,3) == 0
                check = parts(j,:,end) - parts(j+3,:,1);
                checker(i+(p-1)*10,1) = checker(i+(p-1)*10,1) + sum(abs(check));
           end
       end
       for j = 7:9
           if rem(j,3) == 1
                check = parts(j,end,:) - parts(j+1,1,:);
                checker(i+(p-1)*10,1) = checker(i+(p-1)*10,1) + sum(abs(check));
           end
           if rem(j,3) == 2
                check = parts(j,end,:) - parts(j+1,1,:);
                checker(i+(p-1)*10,1) = checker(i+(p-1)*10,1) + sum(abs(check));
           end
       end
      %%[minNum num] = min(checker);
      saveArray(i+(p-1)*10,:,:) = children_local;
        end
    end
    checker_sort = sort(checker);
    for p = 1:5
       checker_find = find(checker(:,1)==checker_sort(p))';
       ch(p,:,:) = saveArray(checker_find(1,1),:,:);
    end
    
    
    %%ch(:,:) = saveArray(num,:,:);
    
    [ch_mutation checker_mutation] = mutation(ch(1,:,:));
    display(checker_mutation);
    if minNum > checker_mutation
       ch = ch_mutation;
    end
    
    end

    function [ch checker_mutation] = mutation(ch_in)
        children_mutation(:,:) = ch_in;
        ch = children_mutation;
        ch = reshape(ch,3,3);
        
        temp = ch(1,:);
        ch(1,:) = ch(3,:);
        ch(3,:) = temp;
        
        temp = ch(2,:);
        ch(2,:) = ch(3,:);
        ch(3,:) = temp;
        
       for j = 1:9
           parts_mutation(j,:,:) = cell2mat(ch(j));
       end
       parts_mutation = double(parts_mutation);
       for j = 1:6
           if rem(j,3) == 1
                check = parts_mutation(j,:,end) - parts_mutation(j+3,:,1);
                checker_mutation = sum(abs(check));
                check = parts_mutation(j,end,:) - parts_mutation(j+1,1,:);
                checker_mutation = checker_mutation + sum(abs(check));
           end
           if rem(j,3) == 2
                check = parts_mutation(j,:,end) - parts_mutation(j+3,:,1);
                checker_mutation = checker_mutation + sum(abs(check));
                check = parts_mutation(j,end,:) - parts_mutation(j+1,1,:);
                checker_mutation = checker_mutation + sum(abs(check));
           end
           if rem(j,3) == 0
                check = parts_mutation(j,:,end) - parts_mutation(j+3,:,1);
                checker_mutation = checker_mutation + sum(abs(check));
           end
       end
       for j = 7:9
           if rem(j,3) == 1
                check = parts_mutation(j,end,:) - parts_mutation(j+1,1,:);
                checker_mutation = checker_mutation + sum(abs(check));
           end
           if rem(j,3) == 2
                check = parts_mutation(j,end,:) - parts_mutation(j+1,1,:);
                checker_mutation = checker_mutation + sum(abs(check));
           end
       end
    end
end