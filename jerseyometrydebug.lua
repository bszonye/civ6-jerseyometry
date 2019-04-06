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

local colors = {
    "COLOR_STANDARD_WHITE_DK",
    "COLOR_STANDARD_WHITE_LT",
    "COLOR_STANDARD_WHITE_MD2",
    "COLOR_STANDARD_WHITE_MD",
    "COLOR_STANDARD_RED_LT",
    "COLOR_STANDARD_RED_MD",
    "COLOR_STANDARD_RED_DK",
    "COLOR_STANDARD_ORANGE_LT",
    "COLOR_STANDARD_ORANGE_MD",
    "COLOR_STANDARD_ORANGE_DK",
    "COLOR_STANDARD_YELLOW_LT",
    "COLOR_STANDARD_YELLOW_MD",
    "COLOR_STANDARD_YELLOW_DK",
    "COLOR_STANDARD_GREEN_LT",
    "COLOR_STANDARD_GREEN_MD",
    "COLOR_STANDARD_GREEN_DK",
    "COLOR_STANDARD_AQUA_LT",
    "COLOR_STANDARD_AQUA_MD",
    "COLOR_STANDARD_AQUA_DK",
    "COLOR_STANDARD_BLUE_LT",
    "COLOR_STANDARD_BLUE_MD",
    "COLOR_STANDARD_BLUE_DK",
    "COLOR_STANDARD_PURPLE_LT",
    "COLOR_STANDARD_PURPLE_MD",
    "COLOR_STANDARD_PURPLE_DK",
    "COLOR_STANDARD_MAGENTA_LT",
    "COLOR_STANDARD_MAGENTA_MD",
    "COLOR_STANDARD_MAGENTA_DK",
}

local short_names = {
    COLOR_STANDARD_WHITE_DK="K0",
    COLOR_STANDARD_WHITE_LT="W3",
    COLOR_STANDARD_WHITE_MD2="W2",
    COLOR_STANDARD_WHITE_MD="W1",
    COLOR_STANDARD_RED_LT="R3",
    COLOR_STANDARD_RED_MD="R2",
    COLOR_STANDARD_RED_DK="R1",
    COLOR_STANDARD_ORANGE_LT="O3",
    COLOR_STANDARD_ORANGE_MD="O2",
    COLOR_STANDARD_ORANGE_DK="O1",
    COLOR_STANDARD_YELLOW_LT="Y3",
    COLOR_STANDARD_YELLOW_MD="Y2",
    COLOR_STANDARD_YELLOW_DK="Y1",
    COLOR_STANDARD_GREEN_LT="G3",
    COLOR_STANDARD_GREEN_MD="G2",
    COLOR_STANDARD_GREEN_DK="G1",
    COLOR_STANDARD_AQUA_LT="A3",
    COLOR_STANDARD_AQUA_MD="A2",
    COLOR_STANDARD_AQUA_DK="A1",
    COLOR_STANDARD_BLUE_LT="B3",
    COLOR_STANDARD_BLUE_MD="B2",
    COLOR_STANDARD_BLUE_DK="B1",
    COLOR_STANDARD_PURPLE_LT="P3",
    COLOR_STANDARD_PURPLE_MD="P2",
    COLOR_STANDARD_PURPLE_DK="P1",
    COLOR_STANDARD_MAGENTA_LT="M3",
    COLOR_STANDARD_MAGENTA_MD="M2",
    COLOR_STANDARD_MAGENTA_DK="M1",
}

function shortname( color :string )
    return short_names[color] or color;
end

local long_names = {
    K0="COLOR_STANDARD_WHITE_DK",
    W3="COLOR_STANDARD_WHITE_LT",
    W2="COLOR_STANDARD_WHITE_MD2",
    W1="COLOR_STANDARD_WHITE_MD",
    R3="COLOR_STANDARD_RED_LT",
    R2="COLOR_STANDARD_RED_MD",
    R1="COLOR_STANDARD_RED_DK",
    O3="COLOR_STANDARD_ORANGE_LT",
    O2="COLOR_STANDARD_ORANGE_MD",
    O1="COLOR_STANDARD_ORANGE_DK",
    Y3="COLOR_STANDARD_YELLOW_LT",
    Y2="COLOR_STANDARD_YELLOW_MD",
    Y1="COLOR_STANDARD_YELLOW_DK",
    G3="COLOR_STANDARD_GREEN_LT",
    G2="COLOR_STANDARD_GREEN_MD",
    G1="COLOR_STANDARD_GREEN_DK",
    A3="COLOR_STANDARD_AQUA_LT",
    A2="COLOR_STANDARD_AQUA_MD",
    A1="COLOR_STANDARD_AQUA_DK",
    B3="COLOR_STANDARD_BLUE_LT",
    B2="COLOR_STANDARD_BLUE_MD",
    B1="COLOR_STANDARD_BLUE_DK",
    P3="COLOR_STANDARD_PURPLE_LT",
    P2="COLOR_STANDARD_PURPLE_MD",
    P1="COLOR_STANDARD_PURPLE_DK",
    M3="COLOR_STANDARD_MAGENTA_LT",
    M2="COLOR_STANDARD_MAGENTA_MD",
    M1="COLOR_STANDARD_MAGENTA_DK",
}

function longname( color :string )
    return long_names[color] or color;
end

function conflict_test( p1 :string, s1 :string, p2 :string, s2 :string )
    local cp1 = UI.GetColorValue(longname(p1 or "K0"));
    local cs1 = UI.GetColorValue(longname(s1 or "K0"));
    local cp2 = UI.GetColorValue(longname(p2 or "K0"));
    local cs2 = UI.GetColorValue(longname(s2 or "K0"));
    if UI.ArePlayerColorsConflicting({cp1,cs1}, {cp2,cs2}) then
        p1 = shortname(p1) or "p";
        s1 = shortname(s1) or "s";
        p2 = shortname(p2) or "p";
        s2 = shortname(s2) or "s";
        print(string.format("%s/%s vs %s/%s", p1, s1, p2, s2));
    end
end

function primary_test( s1 :string, s2 :string)
    s2 = s2 or s1;
    -- print("testing primary conflicts");
    for i,p1 in ipairs(colors) do
        for j,p2 in pairs({unpack(colors, i+1)}) do
            conflict_test(p1, s1, p2, s2);
        end
    end
end

function secondary_test( p1 :string, p2 :string)
    p2 = p2 or p1;
    -- print("testing secondary conflicts");
    for i,s1 in ipairs(colors) do
        for j,s2 in pairs({unpack(colors, i+1)}) do
            conflict_test(p1, s1, p2, s2);
        end
    end
end

-- print("close primary colors");
-- primary_test();
-- print("close secondary colors");
-- secondary_test();
-- print("done");

-- jerseyometry conflicts:
-- p/K0 vs p/R1
-- p/W2 vs p/R3
-- p/W2 vs p/A2
-- p/W1 vs p/A1
-- p/R3 vs p/G3
-- p/R2 vs p/O1
-- p/R2 vs p/G2
-- p/R2 vs p/G1
-- p/R1 vs p/A1
-- p/O3 vs p/Y3
-- p/O3 vs p/Y2
-- p/O3 vs p/Y1
-- p/O3 vs p/G3
-- p/O3 vs p/G2
-- p/O2 vs p/Y1
-- p/O2 vs p/G2
-- p/Y3 vs p/G3
-- p/Y1 vs p/G2
-- p/A3 vs p/P3
-- p/A3 vs p/M3
-- p/A2 vs p/M2
-- p/A1 vs p/M1
-- p/B3 vs p/P3
-- p/B3 vs p/M3
-- p/B2 vs p/P2
-- p/B2 vs p/M2
-- p/B1 vs p/P1
-- p/P3 vs p/M3
-- p/P2 vs p/M2

-- stock conflicts:
-- close primary colors
-- R2/s vs Y1/s
-- B3/s vs M2/s
-- B2/s vs P2/s
-- B1/s vs P1/s
-- close secondary colors
-- p/W3 vs p/A3
-- p/W2 vs p/A2
-- p/W1 vs p/A1
-- p/R2 vs p/O1
-- p/R2 vs p/Y1
-- p/R2 vs p/G1
-- p/R1 vs p/O1
-- p/O3 vs p/O2
-- p/O3 vs p/Y3
-- p/O3 vs p/Y2
-- p/O3 vs p/G3
-- p/O3 vs p/G2
-- p/O2 vs p/G2
-- p/O1 vs p/G1
-- p/Y3 vs p/G3
-- p/Y2 vs p/G3
-- p/A1 vs p/M1
-- p/B3 vs p/P3
-- p/B3 vs p/M3
-- p/B3 vs p/M2
-- p/B2 vs p/P2
-- p/B1 vs p/P1
-- p/B1 vs p/M1
-- p/P3 vs p/M2
-- p/P1 vs p/M1
