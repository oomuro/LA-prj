function PuzzleMaker(src)
   %% load and crop image
    imdata = imread(src);
    imdata = rgb2gray(imdata);
    new_dims = size(imdata) - rem(size(imdata), 3);
    imdata = imdata(1:new_dims(1),1:new_dims(2));
    %% Arrange into 3x3 cell
    block_dims = new_dims./[3 3];
    blocks = mat2cell(imdata, block_dims(1)*ones(3,1), block_dims(2)*ones(3,1));
    lowbound = firstcal();
    %% Rearrange randomly
    blocks(1:9) = blocks(randperm(9));
    %% Return to image
    puzzle = cell2mat(blocks);
    %% Plot input and output
    figure(1)
    imshow(puzzle)
    
    child = [1:9];
    %%표본 만들기(이미지를 cell로 나누는데 이 셀들의 순서를 랜덤으로 생성)
    for i = 1:100
        child(1:9) = child(randperm(9));
        children(i,:) = child;
    end
    %%일단 놔두기
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
   count = 0;
    for k = 1:100
        if k > 1
            count_temp = count_out;
        end
       [ch count_out] = teaching(ch);
       if count_out < lowbound
          for p = 1:5
                    ch_new = mat2cell(imdata, block_dims(1)*ones(3,1), block_dims(2)*ones(3,1));
                    ch_new(1:9) = ch_new(randperm(9));
                    ch(:,:,p) = ch_new; 
          end 
       end
       if count_out == lowbound
           break;
       end
       if k > 1
            if count_temp == count_out
                if count_temp > lowbound + 10000
                    count = count + 1;
                end
            end
            if count > 10
                for p = 1:5
                    ch_new = mat2cell(imdata, block_dims(1)*ones(3,1), block_dims(2)*ones(3,1));
                    ch_new(1:9) = ch_new(randperm(9));
                    ch(:,:,p) = ch_new; 
                end
                count = 0;
            end
       end
       display(k)
    end
        ch_result(:,:) = ch(:,:,1);
        ch_image = cell2mat(ch_result);
        figure(6)
        imshow(ch_image)
        for p = 1:5
            ch_last(:,:) = ch(:,:,1);
            
            if p == 1
                ch_temp = ch_last(1);
                ch_last(1) = ch_last(2);
                ch_last(2) = ch_temp;
            end
            if p == 2
                ch_temp = ch_last(1);
                ch_last(1) = ch_last(3);
                ch_last(3) = ch_temp;
            end
            if p == 3
                ch_temp = ch_last(3);
                ch_last(3) = ch_last(2);
                ch_last(2) = ch_temp;
            end
            if p == 4
                ch_temp = ch_last(1);
                ch_last(1) = ch_last(2);
                ch_last(2) = ch_temp;
                
                ch_temp = ch_last(3);
                ch_last(3) = ch_last(2);
                ch_last(2) = ch_temp;
            end
            if p == 5
                ch_temp = ch_last(1);
                ch_last(1) = ch_last(2);
                ch_last(2) = ch_temp;
                
                ch_temp = ch_last(3);
                ch_last(3) = ch_last(2);
                ch_last(2) = ch_temp;
                
                ch_temp = ch_last(1);
                ch_last(1) = ch_last(2);
                ch_last(2) = ch_temp;
                
                ch_temp = ch_last(3);
                ch_last(3) = ch_last(2);
                ch_last(2) = ch_temp;
            end
            ch(:,:,p) = ch_last;
        end
    [minNum num] = min(checker)
    for p = 1:5
        ch(:,:,p) = reshape(ch(:,:,p),3,3);
        ch_result(:,:) = ch(:,:,p);
        ch_image = cell2mat(ch_result);
        figure(p)
        imshow(ch_image)
    end
    
    
    
    %% 함수부분 시작
    
    function [lowbound] =  firstcal()
        for j = 1:9
           parts(j,:,:) = cell2mat(blocks(j));
       end
       
       parts = double(parts);
       %%모서리에서의 수치값의 차이를 구하는 라인
       for j = 1:6
           if rem(j,3) == 1
                check = parts(j,:,end) - parts(j+3,:,1);
                checker_cal = sum(abs(check));
                check = parts(j,end,:) - parts(j+1,1,:);
                checker_cal = checker_cal + sum(abs(check));
           end
           if rem(j,3) == 2
                check = parts(j,:,end) - parts(j+3,:,1);
                checker_cal = checker_cal + sum(abs(check));
                check = parts(j,end,:) - parts(j+1,1,:);
                checker_cal = checker_cal + sum(abs(check));
           end
           if rem(j,3) == 0
                check = parts(j,:,end) - parts(j+3,:,1);
                checker_cal = checker_cal + sum(abs(check));
           end
       end
       for j = 7:9
           if rem(j,3) == 1
                check = parts(j,end,:) - parts(j+1,1,:);
                checker_cal = checker_cal + sum(abs(check));
           end
           if rem(j,3) == 2
                check = parts(j,end,:) - parts(j+1,1,:);
                checker_cal = checker_cal + sum(abs(check));
           end
       end
       lowbound = checker_cal;
    end
    %% 자식들 생성
    function firstteach()
    for i = 1:100
        %%mat2cell로 cell형태로 변환시키고 cell2mat으로 숫자형태로 바꾼다. 수식연산을 하기 위해선 숫자형태로
        %%바꿔야함.
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
       %%모서리에서의 수치값의 차이를 구하는 라인
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
       %%변형된 cell들을 저장함
       saveArray(:,:,i) = children_local;
    end
    %%sort해서 적은순으로 1등부터 5등까지 저장한뒤 출력하는 곳
    checker_sort = sort(checker);
    for p = 1:5
       checker_find = find(checker(:,1)==checker_sort(p))';
       ch(:,:,p) = saveArray(:,:,checker_find(1,1));
    end
    %%ch = children_local(children(num,:));
    %%ch = reshape(ch,3,3);
    end
    %% 자식들을 받아서 약간 변형시킨 후 값이 적은 5개의 자식들을 출력
    function [ch count_in] = teaching(ch)
    for p = 1:5
        for i = 1:10
        children_local(:,:) = ch(:,:,p);
        if i > 1
            if rem(i,3) == 1
                rand = randperm(9,2);
                temp = children_local(rand(2));
                children_local(rand(2)) = children_local(rand(1));
                children_local(rand(1)) = temp;
            end
            if rem(i,3) == 2
                rand = randperm(9,2);
                temp = children_local(rand(2));
                children_local(rand(2)) = children_local(rand(1));
                children_local(rand(1)) = temp;
                rand = randperm(9,2);
                temp = children_local(rand(2));
                children_local(rand(2)) = children_local(rand(1));
                children_local(rand(1)) = temp;
            end
            if rem(i,3) == 0
                rand = randperm(9,2);
                temp = children_local(rand(2));
                children_local(rand(2)) = children_local(rand(1));
                children_local(rand(1)) = temp;
                rand = randperm(9,2);
                temp = children_local(rand(2));
                children_local(rand(2)) = children_local(rand(1));
                children_local(rand(1)) = temp;
                rand = randperm(9,2);
                temp = children_local(rand(2));
                children_local(rand(2)) = children_local(rand(1));
                children_local(rand(1)) = temp;
            end
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
      [minNum num] = min(checker);
      saveArray(:,:,i+(p-1)*10) = children_local;
        end
    end
    checker_sort = sort(checker);
    
        for p = 1:5
            checker_find = find(checker(:,1)==checker_sort(p))';
            ch(:,:,p) = saveArray(:,:,checker_find(1,1));
        end
    if checker_sort(1) ~= lowbound
        %%ch(:,:) = saveArray(num,:,:);
        for p = 1:5
            [ch_mutation checker_mutation] = mutation(ch(:,:,p));
            if checker_sort(p) > checker_mutation
            ch(:,:,p) = ch_mutation;
            end
        end
    end
    display(checker_sort(1))
    count_in = checker_sort(1);
    end
    %% 돌연변이 생성(이거 잘 안됨)
    function [ch checker_mutation] = mutation(ch_in)
        children_mutation(:,:) = ch_in;
        ch = children_mutation;
        ch = reshape(ch,3,3);
        
        ran = randi(4);
        if  ran == 1
            temp = ch(1,:);
            ch(1,:) = ch(3,:);
            ch(3,:) = temp;
        
            temp = ch(2,:);
            ch(2,:) = ch(3,:);
            ch(3,:) = temp;
        end
        if ran == 2
            temp = ch(:,1);
            ch(:,1) = ch(:,3);
            ch(:,3) = temp;
        
            temp = ch(:,2);
            ch(:,2) = ch(:,3);
            ch(:,3) = temp;
        end
        if  ran == 3
            temp = ch(1,:);
            ch(1,:) = ch(2,:);
            ch(2,:) = temp;
        
            temp = ch(2,:);
            ch(2,:) = ch(3,:);
            ch(3,:) = temp;
        end
        if ran == 4
            temp = ch(:,1);
            ch(:,1) = ch(:,2);
            ch(:,2) = temp;
        
            temp = ch(:,2);
            ch(:,2) = ch(:,3);
            ch(:,3) = temp;
        end
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