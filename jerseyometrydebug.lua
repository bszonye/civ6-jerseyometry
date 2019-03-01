function rgba_color(r :number, g :number, b :number, a :number)
    if a == nil then
        a = 255
    end
    return ((a * 256 + b) * 256 + g) * 256 + r;
end

function color_rgba(abgr :number)
    local rgba :table = {}
    rgba.r = abgr % 0x100;
    rgba.g = math.floor(abgr / 0x100) % 0x100;
    rgba.b = math.floor(abgr / 0x10000) % 0x100;
    rgba.a = math.floor(abgr / 0x1000000) % 0x100;
    return rgba
end

function print_color( name :string, abgr :number )
    if abgr == nil then
        abgr = UI.GetColorValue(name);
    end
    local rgba = color_rgba(abgr)
    print(string.format("%s = %d = %d,%d,%d,%d",
                        name, abgr, rgba.r, rgba.g, rgba.b, rgba.a))
end

function conflict_test( a :string, b :string )
    local white = UI.GetColorValue("white");
    local aa = { UI.GetColorValue(a), white };
    local bb = { UI.GetColorValue(b), white };
    print_color(a);
    print_color(b);
    if UI.ArePlayerColorsConflicting(aa, bb) then
        print("conflict");
    else
        print("ok");
    end
end

-- conflict_test("COLOR_WHITE", "255,255,255");
