#ifndef BLEND_FUNCTION_H
#define BLEND_FUNCTION_H

//A : DstColor
//B : SrcColor

half3 BlendDefault(half3 A, half3 B)
{
    return B;
}

half3 BlendDarken(half3 A, half B)
{
    return min(B, A);
}

half3 BlendMultiply(half3 A, half3 B)
{
    return A * B;
}

half3 BlendColorBurn(half3 A, half3 B)
{    
    return 1 - (1 - A) / B;
}

half3 BlendLinearBurn(half3 A, half3 B)
{
    return B + A - 1;
}

half3 BlendLighten(half3 A, half3 B)
{
    return max(B, A);
}

half3 BlendScreen(half3 A, half3 B)
{
    return B + A - B * A;
}

half3 BlendColorDodge(half3 A, half3 B)
{
    return A / (1 - B);
}

half3 BlendLinearDodge(half3 A, half3 B)
{
    return B + A;
}

half3 BlendOverlay(half3 A, half3 B)
{
    return (A > 0.5) ? 1 - (1 - 2 * (A - 0.5)) * (1 - B) : 2 * A * B;
}

half3 BlendSoftLight(half3 A, half3 B)
{
    return (B > 0.5) ? 1 - (1 - A) * (1 - (B - 0.5)) : A * (B + 0.5);
}

half3 BlendHardLight(half3 A, half3 B)
{
    return (B > 0.5) ? 1 - (1 - A) * (1 - 2 * (B - 0.5)) : A * 2 * B;
}

half3 BlendVividLight(half3 A, half3 B)
{
    return (B > 0.5) ? 1 - (1 - A) / (2 * (B - 0.5)) : A / (1 - 2 * B);
}

half3 BlendLinearLight(half3 A, half3 B)
{
    return (B > 0.5) ? A + 2 * (B - 0.5) : A + 2 * B - 1;
}

#endif