function aRatio = computeAspectRatio(image, printMode)
    [num_rows, num_cols] = size(image);

    counter = 1;
    for i = 1: num_rows
        row = find(image(i,:));
        if ~isempty(row)
            left(counter) = min(row);
            right(counter) = max(row);
            counter = counter +1;
        end
    end
    left = min(left);
    right = max(right);

    counter = 1;
    for i = 1: num_cols
        column = find(image(:,i));
        if ~isempty(column)
            up(counter) = min(column);
            down(counter) = max(column);
            counter = counter +1;
        end
    end
    up = min(up);
    down = max(down);

    width = right - left;
    height = down - up;

    aRatio = width / height;

    if(printMode > 0)
        imagesc(image);
        colormap(gray)
        line([left-1/2 right+1/2], [up-1/2, up-1/2], 'Color', 'r', 'LineWidth',5);
        line([right+1/2 right+1/2], [up-1/2, down+1/2], 'Color', 'r', 'LineWidth',5);
        line([left-1/2 right+1/2], [down+1/2 down+1/2], 'Color', 'r', 'LineWidth',5);
        line([left-1/2 left-1/2], [down+1/2 up-1/2], 'Color', 'r', 'LineWidth',5);
    end
end

