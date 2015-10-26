function F = hdf_snapshot(data, timestamps, flags)
    % TODO: loop through the cell array instead of unpacking
    % it should be faster
    if ~exist('flags', 'var') || isempty(flags)
        flags = [1 1 1 1 1 1 1];
    end

    col = 1;
    s = 0;
    
    if flags(1) == 1
        analog = unpack(data.analog);
        [~, i_analog] = find_closest(timestamps, analog(:, col));
        s = s + size(analog, 2) - 1;
    end
    if flags(2) == 1
        state = unpack(data.state);
        [~, i_state] = find_closest(timestamps, state(:, col));
        s = s + size(state, 2) - 1;
    end
    if flags(3) == 1
        springy = unpack(data.springy);
        [~, i_springy] = find_closest(timestamps, springy(:, col));
        s = s + size(springy, 2) - 1;
    end
    if flags(4) == 1
        skin = unpack(data.skin);
        [~, i_skin] = find_closest(timestamps, skin(:, col));
        s = s + size(skin, 2) - 1;
    end
    if flags(5) == 1
        skin_comp = unpack(data.skin_comp);
        [~, i_skin_comp] = find_closest(timestamps, skin_comp(:, col));
        s = s + size(skin_comp, 2) - 1;
    end
    if flags(6) == 1
        wrench = unpack(data.wrench);
        [~, i_wrench] = find_closest(timestamps, wrench(:, col));
        s = s + size(wrench, 2) - 1;
    end
    if flags(7) == 1
        cart_wrench = unpack(data.cart_wrench);
        [~, i_cart_wrench] = find_closest(timestamps, cart_wrench(:, col));
        s = s + size(cart_wrench, 2) - 1;
    end
    
    F = zeros(size(data.analog, 1), s);
    
    next = 1;
    if flags(1) == 1
        last = next + size(analog, 2) - 2;
        F(:, next:last) = analog(i_analog, 2:end);
        next = last + 1;
    end
    if flags(2) == 1
        last = next + size(state, 2) - 2;
        F(:, next:last) = state(i_state, 2:end);
        next = last + 1;
    end
    if flags(3) == 1
        last = next + size(springy, 2) - 2;
        F(:, next:last) = springy(i_springy, 2:end);
        next = last + 1;
    end
    if flags(4) == 1
        last = next + size(skin, 2) - 2;
        F(:, next:last) = skin(i_skin, 2:end);
        next = last + 1;
    end
    if flags(5) == 1
        last = next + size(skin_comp, 2) - 2;
        F(:, next:last) = skin_comp(i_skin_comp, 2:end);
        next = last + 1;
    end
    if flags(6) == 1
        last = next + size(wrench, 2) - 2;
        F(:, next:last) = wrench(i_wrench, 2:end);
        next = last + 1;
    end
    if flags(7) == 1
        last = next + size(cart_wrench, 2) - 2;
        F(:, next:last) = cart_wrench(i_cart_wrench, 2:end);
        next = last + 1;
    end
    
end