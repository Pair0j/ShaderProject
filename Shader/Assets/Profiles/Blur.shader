Shader "PostProcessing/Blur"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
        _Spread("Standard Deviation (Spread)", Float) = 1
        _GridSize("Grid Size", Integer) = 5
    }

    SubShader
    {
        Tags
        {
            "RenderType" = "Opaque"
            "RenderPipeline" = "UniversalPipeline"
        }

        HLSLINCLUDE

        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

        TEXTURE2D(_MainTex);
        SAMPLER(sampler_MainTex);

        CBUFFER_START(UnityPerMaterial)
            float4 _MainTex_TexelSize;
            int _GridSize;
            float _Spread;
        CBUFFER_END

        float gaussian(int x)
        {
            float sigmaSqu = max(_Spread * _Spread, 0.0001);
            return (1.0 / sqrt(TWO_PI * sigmaSqu)) *
                   exp(-(x * x) / (2.0 * sigmaSqu));
        }

        struct appdata
        {
            float4 positionOS : POSITION;
            float2 uv : TEXCOORD0;
        };

        struct v2f
        {
            float4 positionCS : SV_POSITION;
            float2 uv : TEXCOORD0;
        };

        v2f vert(appdata v)
        {
            v2f o;
            o.positionCS = TransformObjectToHClip(v.positionOS.xyz);
            o.uv = v.uv;
            return o;
        }

        ENDHLSL

        Pass
        {
            Name "Horizontal"

            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag_horizontal

            float4 frag_horizontal(v2f i) : SV_Target
            {
                float3 col = float3(0,0,0);
                float gridSum = 0;

                int upper = (_GridSize - 1) / 2;
                int lower = -upper;

                for (int x = lower; x <= upper; x++)
                {
                    float g = gaussian(x);
                    gridSum += g;

                    float2 uv = i.uv + float2(_MainTex_TexelSize.x * x, 0);
                    col += g * SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, uv).rgb;
                }

                col /= max(gridSum, 0.0001);
                return float4(col, 1);
            }

            ENDHLSL
        }

        Pass
        {
            Name "Vertical"

            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag_vertical

            float4 frag_vertical(v2f i) : SV_Target
            {
                float3 col = float3(0,0,0);
                float gridSum = 0;

                int upper = (_GridSize - 1) / 2;
                int lower = -upper;

                for (int y = lower; y <= upper; y++)
                {
                    float g = gaussian(y);
                    gridSum += g;

                    float2 uv = i.uv + float2(0, _MainTex_TexelSize.y * y);
                    col += g * SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, uv).rgb;
                }

                col /= max(gridSum, 0.0001);
                return float4(col, 1);
            }

            ENDHLSL
        }
    }
}