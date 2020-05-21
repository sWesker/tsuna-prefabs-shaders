// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Tsuna/Dissolve SS"
{
	Properties
	{
		_MainTex("Albedo Map", 2D) = "white" {}
		_Color("Color", Color) = (1,1,1,0)
		_EmissionMap("EmissionMap", 2D) = "white" {}
		[HDR]_EmissionColor("EmissionColor", Color) = (1,1,1,0)
		[SingleLineTexture]_DissolveGradient("DissolveGradient", 2D) = "white" {}
		_DissolveProgress("DissolveProgress", Range( 0 , 1)) = 10
		_TilingandOffset("Tiling and Offset", Vector) = (1,1,0,0)
		_Offset("Offset", Range( 1 , 10)) = 5.256104
		[HDR]_DissolveColor("DissolveColor", Color) = (1,1,1,0)
		[Toggle(_)]_ToggleTime("Toggle Time", Float) = 0
		_Vector2("Vector 2", Vector) = (1,1,0,0)
		[Toggle(_)]_ToggleChroma("Toggle Chroma", Float) = 0
		_DissolveMap("DissolveMap", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" }
		Cull Back
		ZWrite On
		ZTest LEqual
		Blend SrcAlpha OneMinusSrcAlpha
		
		GrabPass{ }
		CGPROGRAM
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#if defined(UNITY_STEREO_INSTANCING_ENABLED) || defined(UNITY_STEREO_MULTIVIEW_ENABLED)
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex);
		#else
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex)
		#endif
		#pragma surface surf StandardCustomLighting keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
			float4 screenPos;
		};

		struct SurfaceOutputCustomLightingCustom
		{
			half3 Albedo;
			half3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			half Alpha;
			Input SurfInput;
			UnityGIInput GIData;
		};

		uniform float4 _Color;
		uniform sampler2D _MainTex;
		uniform float4 _TilingandOffset;
		uniform float _ToggleChroma;
		uniform sampler2D _DissolveGradient;
		uniform sampler2D _DissolveMap;
		uniform float4 _DissolveMap_ST;
		uniform float4 _Vector2;
		uniform float _ToggleTime;
		uniform float _DissolveProgress;
		uniform float _Offset;
		uniform float4 _DissolveColor;
		uniform float4 _EmissionColor;
		uniform sampler2D _EmissionMap;
		ASE_DECLARE_SCREENSPACE_TEXTURE( _GrabTexture )


		float3 HSVToRGB( float3 c )
		{
			float4 K = float4( 1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0 );
			float3 p = abs( frac( c.xxx + K.xyz ) * 6.0 - K.www );
			return c.z * lerp( K.xxx, saturate( p - K.xxx ), c.y );
		}


		inline float4 ASE_ComputeGrabScreenPos( float4 pos )
		{
			#if UNITY_UV_STARTS_AT_TOP
			float scale = -1.0;
			#else
			float scale = 1.0;
			#endif
			float4 o = pos;
			o.y = pos.w * 0.5f;
			o.y = ( pos.y - o.y ) * _ProjectionParams.x * scale + o.y;
			return o;
		}


		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			float2 appendResult146 = (float2(_TilingandOffset.x , _TilingandOffset.y));
			float2 appendResult145 = (float2(_TilingandOffset.z , _TilingandOffset.w));
			float2 uv_TexCoord144 = i.uv_texcoord * appendResult146 + appendResult145;
			float grayscale33 = dot(float3(0,0,0), float3(0.299,0.587,0.114));
			float2 uv0_DissolveMap = i.uv_texcoord * _DissolveMap_ST.xy + _DissolveMap_ST.zw;
			float2 appendResult76 = (float2((uv0_DissolveMap.x*_Vector2.x + _Vector2.z) , (uv0_DissolveMap.y*_Vector2.y + _Vector2.w)));
			float grayscale29 = dot(tex2D( _DissolveMap, appendResult76 ).rgb, float3(0.299,0.587,0.114));
			float temp_output_99_0 = (0.0 + (sin( _Time.y ) - -1.0) * (1.0 - 0.0) / (1.0 - -1.0));
			float ifLocalVar95 = 0;
			if( _ToggleTime == 1.0 )
				ifLocalVar95 = temp_output_99_0;
			else
				ifLocalVar95 = _DissolveProgress;
			float lerpResult13 = lerp( grayscale33 , grayscale29 , ifLocalVar95);
			float grayscale30 = dot(float3(1,1,1), float3(0.299,0.587,0.114));
			float lerpResult9 = lerp( grayscale29 , grayscale30 , ifLocalVar95);
			float lerpResult16 = lerp( lerpResult13 , lerpResult9 , ifLocalVar95);
			float clampResult63 = clamp( (( 0.0 - _Offset ) + (lerpResult16 - 0.0) * (_Offset - ( 0.0 - _Offset )) / (1.0 - 0.0)) , 0.0 , 1.0 );
			float temp_output_64_0 = ( 1.0 - clampResult63 );
			float2 appendResult65 = (float2(temp_output_64_0 , 0.0));
			float4 tex2DNode66 = tex2D( _DissolveGradient, appendResult65 );
			float4 temp_output_93_0 = ( tex2DNode66 * 5.0 * temp_output_64_0 * _DissolveColor );
			float3 hsvTorgb3_g1 = HSVToRGB( float3(temp_output_99_0,1.0,1.0) );
			float4 ifLocalVar107 = 0;
			if( _ToggleChroma == 1.0 )
				ifLocalVar107 = ( ( float4( hsvTorgb3_g1 , 0.0 ) * 5.0 * tex2DNode66 * _DissolveColor ) * temp_output_64_0 );
			else
				ifLocalVar107 = temp_output_93_0;
			float4 clampResult149 = clamp( ( ( _Color * tex2D( _MainTex, uv_TexCoord144 ) ) + ( ifLocalVar107 + ( _EmissionColor * tex2D( _EmissionMap, uv_TexCoord144 ) ) ) ) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ase_screenPos );
			float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
			float4 screenColor83 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,ase_grabScreenPosNorm.xy/ase_grabScreenPosNorm.w);
			float4 lerpResult84 = lerp( clampResult149 , screenColor83 , temp_output_64_0);
			c.rgb = lerpResult84.rgb;
			c.a = 1;
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17900
492;450.4;2156;1100;-938.8427;945.7227;1;True;False
Node;AmplifyShaderEditor.TexturePropertyNode;118;-4049.685,-338.8733;Inherit;True;Property;_DissolveMap;DissolveMap;12;0;Create;True;0;0;False;0;None;ccb577db1b5d0a742a19dd713430863d;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.Vector4Node;133;-2982.187,142.8947;Inherit;False;Property;_Vector2;Vector 2;10;0;Create;True;0;0;False;0;1,1,0,0;50,50,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;130;-3022.787,-5.105227;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;97;-3006.456,-397.342;Inherit;False;Constant;_Speed;Speed;12;0;Create;True;0;0;False;0;1;0;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;74;-2600.043,-103.7041;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;96;-2689.456,-397.342;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;75;-2594.842,34.09565;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;98;-2502.48,-408.3221;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;76;-2345.242,-59.50427;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;94;-2369.233,-523.7027;Inherit;False;Property;_ToggleTime;Toggle Time;9;0;Create;True;0;0;False;1;Toggle(_);0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;99;-2344.48,-424.4836;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;31;-1560.728,132.5401;Inherit;True;Constant;_Vector0;Vector 0;6;0;Create;True;0;0;False;0;1,1,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;32;-1619.766,-638.6647;Inherit;True;Constant;_Vector1;Vector 1;6;0;Create;True;0;0;False;0;0,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;8;-2457.153,-229.2014;Inherit;False;Property;_DissolveProgress;DissolveProgress;5;0;Create;True;0;0;False;0;10;0.694;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-2101.448,-96.98999;Inherit;True;Property;_D;D;4;1;[SingleLineTexture];Create;True;0;0;False;0;-1;deb2cca25ab52e64c8d786f569c06f5b;ccb577db1b5d0a742a19dd713430863d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCGrayscale;29;-1691.214,-85.21899;Inherit;False;1;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCGrayscale;30;-1271.953,347.8605;Inherit;True;1;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;95;-2042.456,-322.342;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCGrayscale;33;-1299.728,-466.4599;Inherit;True;1;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;68;-883.7698,-399.1524;Inherit;False;Property;_Offset;Offset;7;0;Create;True;0;0;False;0;5.256104;3.43;1;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;9;-949.0819,-31.37239;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;13;-928.114,-290.1816;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;16;-615.4421,-136.1846;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;70;-463.5732,-352.4939;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;62;-301.489,-76.61041;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-4;False;4;FLOAT;4;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;63;56.72959,-80.79115;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;64;216.1653,-283.0036;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;65;404.1256,-204.6049;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector4Node;147;-1732.545,600.0984;Inherit;False;Property;_TilingandOffset;Tiling and Offset;6;0;Create;True;0;0;False;0;1,1,0,0;1,1,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;145;-1464.545,714.0985;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;108;775.6729,-307.841;Inherit;False;Simple HUE;-1;;1;32abb5f0db087604486c2db83a2e817a;0;1;1;FLOAT;0;False;4;FLOAT3;6;FLOAT;7;FLOAT;5;FLOAT;8
Node;AmplifyShaderEditor.ColorNode;92;646.8828,71.34383;Inherit;False;Property;_DissolveColor;DissolveColor;8;1;[HDR];Create;True;0;0;False;0;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;111;870.7273,140.5441;Inherit;False;Constant;_Float0;Float 0;13;0;Create;True;0;0;False;0;5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;66;601.0206,-154.8938;Inherit;True;Property;_DissolveGradient;DissolveGradient;4;1;[SingleLineTexture];Create;True;0;0;False;0;-1;None;e83a5e64e40ce6a4eaf968b6c769a2c0;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;0,0;False;1;FLOAT2;1,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;146;-1461.545,561.0985;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;109;1135.199,-239.218;Inherit;False;4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;144;-1276.545,608.0984;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;93;1161.436,-74.17869;Inherit;True;4;4;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;79;578.84,474.2315;Inherit;True;Property;_EmissionMap;EmissionMap;2;0;Create;True;0;0;False;0;-1;None;db0e0545abb52ea45b2375c99c78af9b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;106;1151.702,-456.2177;Inherit;False;Property;_ToggleChroma;Toggle Chroma;11;0;Create;True;0;0;False;1;Toggle(_);0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;78;651.6085,264.0236;Inherit;False;Property;_EmissionColor;EmissionColor;3;1;[HDR];Create;True;0;0;False;0;1,1,1,0;2,2,2,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;110;1445.654,-293.5193;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ConditionalIfNode;107;1685.531,-301.5544;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;1;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;77;966.1021,376.4089;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;17;-402.7529,-990.6326;Inherit;False;Property;_Color;Color;1;0;Create;True;0;0;False;0;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;50;-495.5215,-805.5018;Inherit;True;Property;_MainTex;Albedo Map;0;0;Create;False;0;0;False;0;-1;None;0ad9b3b9e20ca094793ed614245a009f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;105;1856.655,-139.5799;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;49;612.7372,-813.3896;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;81;1922.482,-611.9951;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GrabScreenPosition;119;314.6523,-578.4041;Inherit;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenColorNode;83;648.7188,-575.4171;Inherit;False;Global;_GrabScreen0;Grab Screen 0;12;0;Create;True;0;0;False;0;Object;-1;False;True;1;0;FLOAT4;0,0,0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;149;2225.843,-623.7227;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;84;2474.426,-554.0228;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2996.567,-573.3973;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;Tsuna/Dissolve SS;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;1;False;-1;3;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;TransparentCutout;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;True;2;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;130;2;118;0
WireConnection;74;0;130;1
WireConnection;74;1;133;1
WireConnection;74;2;133;3
WireConnection;96;0;97;0
WireConnection;75;0;130;2
WireConnection;75;1;133;2
WireConnection;75;2;133;4
WireConnection;98;0;96;0
WireConnection;76;0;74;0
WireConnection;76;1;75;0
WireConnection;99;0;98;0
WireConnection;1;0;118;0
WireConnection;1;1;76;0
WireConnection;29;0;1;0
WireConnection;30;0;31;0
WireConnection;95;0;94;0
WireConnection;95;2;8;0
WireConnection;95;3;99;0
WireConnection;95;4;8;0
WireConnection;33;0;32;0
WireConnection;9;0;29;0
WireConnection;9;1;30;0
WireConnection;9;2;95;0
WireConnection;13;0;33;0
WireConnection;13;1;29;0
WireConnection;13;2;95;0
WireConnection;16;0;13;0
WireConnection;16;1;9;0
WireConnection;16;2;95;0
WireConnection;70;1;68;0
WireConnection;62;0;16;0
WireConnection;62;3;70;0
WireConnection;62;4;68;0
WireConnection;63;0;62;0
WireConnection;64;0;63;0
WireConnection;65;0;64;0
WireConnection;145;0;147;3
WireConnection;145;1;147;4
WireConnection;108;1;99;0
WireConnection;66;1;65;0
WireConnection;146;0;147;1
WireConnection;146;1;147;2
WireConnection;109;0;108;6
WireConnection;109;1;111;0
WireConnection;109;2;66;0
WireConnection;109;3;92;0
WireConnection;144;0;146;0
WireConnection;144;1;145;0
WireConnection;93;0;66;0
WireConnection;93;1;111;0
WireConnection;93;2;64;0
WireConnection;93;3;92;0
WireConnection;79;1;144;0
WireConnection;110;0;109;0
WireConnection;110;1;64;0
WireConnection;107;0;106;0
WireConnection;107;2;93;0
WireConnection;107;3;110;0
WireConnection;107;4;93;0
WireConnection;77;0;78;0
WireConnection;77;1;79;0
WireConnection;50;1;144;0
WireConnection;105;0;107;0
WireConnection;105;1;77;0
WireConnection;49;0;17;0
WireConnection;49;1;50;0
WireConnection;81;0;49;0
WireConnection;81;1;105;0
WireConnection;83;0;119;0
WireConnection;149;0;81;0
WireConnection;84;0;149;0
WireConnection;84;1;83;0
WireConnection;84;2;64;0
WireConnection;0;13;84;0
ASEEND*/
//CHKSM=6A4D9ECFE7C87E68CC086FB59A30110030CA01FF