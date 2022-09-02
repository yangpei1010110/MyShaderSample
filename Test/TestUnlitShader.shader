// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unlit/TestUnlitShader"
{
    Properties
    {
        [NoScaleOffset] _MainTex ("Texture", 2D) = "white" {}
        [PowerSlider(2)] _TestFloat ("测试浮点", Range(0,1)) = 0.5
        _TestVector ("测试向量", Vector) = (0,0,0,0)
    }
    SubShader
    {
        Tags
        {
            "RenderType"="Opaque"
            "Queue"="Geometry+1"
        }
        LOD 100

        cull off
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct a2v
            {
                fixed4 vertex : POSITION;
                fixed4 uv : TEXCOORD0;
                fixed3 normal : NORMAL;
                fixed4 color : COLOR0;
            };

            struct v2f
            {
                fixed2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                fixed4 vertex : SV_POSITION;
                fixed4 color : COLOR0;
            };

            sampler2D _MainTex;
            fixed4 _MainTex_ST;

            v2f vert(a2v v)
            {
                v2f o;
                // o.vertex = UnityObjectToClipPos(v.vertex);
                // o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                // UNITY_TRANSFER_FOG(o, o.vertex);

                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                // o.color = fixed4(v.normal * 0.5 + fixed3(0.5, 0.5, 0.5), 1.0);
                o.color = fixed4(v.uv.xy, 0.0, 1.0);
                return o;
            }

            fixed checker(fixed2 uv)
            {
                fixed2 repeat_uv = uv * 10;
                fixed2 c = floor(repeat_uv) / 20;

                float checker = frac(c.x + c.y) * 1;
                return checker * uv;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                // // sample the texture
                // fixed4 col = tex2D(_MainTex, i.uv);
                // // apply fog
                // UNITY_APPLY_FOG(i.fogCoord, col);
                // return col;

                // return checker(i.uv);

                return i.color;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
//    CustomEditor "EditorName"
}