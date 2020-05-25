// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Tsuna/Hue Shift FX"
{
	Properties
	{
		[Header(Shader by tsuna vr)][Header(Discord bDWEYUw)][Header(Visit for commissions and free stuff)][Space(25)][Toggle(_)]_ThanksforusingmyShader("Thanks for using my Shader!", Float) = 0
		[SingleLineTexture][Header(Main)]_MainTex("Albedo Map", 2D) = "white" {}
		_AlbedoHue("Albedo Hue", Range( 0 , 1)) = 0
		_AlbedoLuminosity("Albedo Luminosity", Range( 0 , 1)) = 0
		_Color("Albedo Color", Color) = (1,1,1,0)
		[SingleLineTexture]_MetallicGlossMap("Metallic Map", 2D) = "white" {}
		_Metaliic("Metallic Slider", Range( 0 , 1)) = 0
		_Glossiness("Smoothness Slider", Range( 0 , 1)) = 0
		[Toggle(_)]_UseNormalMap("Use Normal Map", Float) = 0
		[Normal][SingleLineTexture]_BumpMap("Normal Map", 2D) = "bump" {}
		_NormalMapSlider("Normal Map Slider", Range( 0 , 5)) = 1
		[SingleLineTexture]_EmissionMap1("Emission Map", 2D) = "black" {}
		_EmissionHue("Emission Hue", Range( 0 , 1)) = 0
		_EmissionLuminosity("Emission Luminosity", Range( 0 , 1)) = 0
		[HDR]_EmissionColor("Emission Color", Color) = (0,0,0,0)
		_TilingandOffset("Tiling and Offset", Vector) = (1,1,0,0)
		[Header(Culling)]_BackfaceDimming("Backface Dimming", Range( 0 , 1)) = 0
		_CullMode("Cull Mode ( 0 = None, 1 = Front, 2 = Back)", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull [_CullMode]
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
			half ASEVFace : VFACE;
		};

		uniform float _ThanksforusingmyShader;
		uniform float _CullMode;
		uniform float _UseNormalMap;
		uniform float _NormalMapSlider;
		uniform sampler2D _BumpMap;
		uniform float4 _TilingandOffset;
		uniform float _AlbedoHue;
		uniform float4 _Color;
		uniform float _AlbedoLuminosity;
		uniform sampler2D _MainTex;
		uniform float _BackfaceDimming;
		uniform float _EmissionHue;
		uniform sampler2D _EmissionMap1;
		uniform float _EmissionLuminosity;
		uniform float4 _EmissionColor;
		uniform float _Metaliic;
		uniform sampler2D _MetallicGlossMap;
		uniform float _Glossiness;


		float3 HSVToRGB( float3 c )
		{
			float4 K = float4( 1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0 );
			float3 p = abs( frac( c.xxx + K.xyz ) * 6.0 - K.www );
			return c.z * lerp( K.xxx, saturate( p - K.xxx ), c.y );
		}


		float3 RGBToHSV(float3 c)
		{
			float4 K = float4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
			float4 p = lerp( float4( c.bg, K.wz ), float4( c.gb, K.xy ), step( c.b, c.g ) );
			float4 q = lerp( float4( p.xyw, c.r ), float4( c.r, p.yzx ), step( p.x, c.r ) );
			float d = q.x - min( q.w, q.y );
			float e = 1.0e-10;
			return float3( abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 _Vector1 = float3(0,0,1);
			float2 appendResult53 = (float2(_TilingandOffset.x , _TilingandOffset.y));
			float2 appendResult52 = (float2(_TilingandOffset.z , _TilingandOffset.w));
			float2 uv_TexCoord54 = i.uv_texcoord * appendResult53 + appendResult52;
			float3 ifLocalVar50 = 0;
			if( _UseNormalMap == 1.0 )
				ifLocalVar50 = UnpackScaleNormal( tex2D( _BumpMap, uv_TexCoord54 ), _NormalMapSlider );
			else
				ifLocalVar50 = _Vector1;
			o.Normal = ifLocalVar50;
			float3 hsvTorgb13 = RGBToHSV( ( _Color * ( _AlbedoLuminosity + tex2D( _MainTex, uv_TexCoord54 ) ) ).rgb );
			float3 hsvTorgb14 = HSVToRGB( float3(( _AlbedoHue + hsvTorgb13.x ),hsvTorgb13.y,hsvTorgb13.z) );
			o.Albedo = ( hsvTorgb14 * (_BackfaceDimming + (i.ASEVFace - -1.0) * (1.0 - _BackfaceDimming) / (1.0 - -1.0)) );
			float3 hsvTorgb77 = RGBToHSV( ( tex2D( _EmissionMap1, uv_TexCoord54 ) * ( _EmissionLuminosity + _EmissionColor ) ).rgb );
			float3 hsvTorgb76 = HSVToRGB( float3(( _EmissionHue + hsvTorgb77.x ),hsvTorgb77.y,hsvTorgb77.z) );
			o.Emission = hsvTorgb76;
			float4 tex2DNode57 = tex2D( _MetallicGlossMap, uv_TexCoord54 );
			o.Metallic = ( _Metaliic * tex2DNode57 ).r;
			o.Smoothness = ( _Glossiness * tex2DNode57.a );
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18100
162.4;109.6;2608;1488;5609.485;1487.178;3.058629;True;False
Node;AmplifyShaderEditor.Vector4Node;51;-1069.355,659.8133;Inherit;False;Property;_TilingandOffset;Tiling and Offset;15;0;Create;False;0;0;False;0;False;1,1,0,0;1,1,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;52;-801.355,773.8134;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;53;-798.355,620.8132;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;54;-613.355,667.8133;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;71;-341.5153,561.9141;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;72;-2501.365,564.9949;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;88;-2249.064,-189.6099;Float;False;Property;_AlbedoLuminosity;Albedo Luminosity;3;0;Create;True;0;0;False;0;False;0;0.214;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;66;-2265.563,-74.28673;Inherit;True;Property;_MainTex;Albedo Map;1;1;[SingleLineTexture];Create;False;0;0;False;1;Header(Main);False;-1;03bb83f35fcc7c942b160033a07cebbd;d9e4646a272cbf04aa435c599f4d4a49;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;68;-2213.23,-376.4244;Inherit;False;Property;_Color;Albedo Color;4;0;Create;False;0;0;False;0;False;1,1,1,0;1,0,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;69;-430.8671,521.8596;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;87;-1908.064,-164.6099;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;70;-2310.336,509.535;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;89;-2225.064,514.3901;Float;False;Property;_EmissionLuminosity;Emission Luminosity;13;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;67;-1762.49,-307.3946;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;63;-2168.528,323.0423;Inherit;False;Property;_EmissionColor;Emission Color;14;1;[HDR];Create;False;0;0;False;0;False;0,0,0,0;0,0,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;64;-2255.37,122.0514;Inherit;True;Property;_EmissionMap1;Emission Map;11;1;[SingleLineTexture];Create;False;0;0;False;0;False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;90;-1889.064,296.3901;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RGBToHSVNode;13;-1596.957,-330.5377;Float;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;73;-1604.126,-568.1205;Float;False;Property;_AlbedoHue;Albedo Hue;2;0;Create;True;0;0;False;0;False;0;0.618;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;74;-1258.126,-477.1205;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;65;-1753.156,195.5303;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FaceVariableNode;81;92.68723,-254.7376;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;45;-157.4677,1151.548;Inherit;False;Property;_NormalMapSlider;Normal Map Slider;10;0;Create;False;0;0;False;0;False;1;1;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;79;-1594.423,-91.84467;Float;False;Property;_EmissionHue;Emission Hue;12;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RGBToHSVNode;77;-1587.254,143.7381;Float;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.HSVToRGBNode;14;-1088.107,-307.8064;Float;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;80;-76.74878,-144.6889;Inherit;False;Property;_BackfaceDimming;Backface Dimming;16;0;Create;False;0;0;False;1;Header(Culling);False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;46;-296.7769,957.1048;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;57;-108.9133,501.6994;Inherit;True;Property;_MetallicGlossMap;Metallic Map;5;1;[SingleLineTexture];Create;False;0;0;False;0;False;-1;None;8d137726a7ca7644486c5d5cb81292eb;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;82;271.0363,-205.9225;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;0.1;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;49;288.1191,1321.451;Inherit;False;Constant;_Vector1;Vector 0;11;0;Create;True;0;0;False;0;False;0,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;48;252.7704,1018.442;Inherit;False;Property;_UseNormalMap;Use Normal Map;8;0;Create;False;0;0;False;1;Toggle(_);False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;47;154.8298,1105.548;Inherit;True;Property;_BumpMap;Normal Map;9;2;[Normal];[SingleLineTexture];Create;False;0;0;False;0;False;-1;None;4d4615a1f7d8dc64db2bc069e8a4d8df;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;0;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;78;-1248.423,-2.844696;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;59;-92.5462,702.2386;Inherit;False;Property;_Glossiness;Smoothness Slider;7;0;Create;False;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;85;-243.7503,-64.66988;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;58;-95.41284,406.3321;Inherit;False;Property;_Metaliic;Metallic Slider;6;0;Create;False;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;86;-3232.193,1462.326;Inherit;False;Property;_ThanksforusingmyShader;Thanks for using my Shader!;0;0;Create;False;0;0;True;5;Header(Shader by tsuna vr);Header(Discord bDWEYUw);Header(Visit for commissions and free stuff);Space(25);Toggle(_);False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;83;581.2692,-28.42949;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ConditionalIfNode;50;497.3433,1170.813;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;62;916.365,436.9506;Inherit;False;Property;_CullMode;Cull Mode ( 0 = None, 1 = Front, 2 = Back);17;0;Create;False;0;0;True;1;;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;60;294.7252,445.2373;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.HSVToRGBNode;76;-1078.404,166.4694;Float;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;61;293.51,602.6454;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;918.0816,-4.84771;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Tsuna/Hue Shift FX;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;True;62;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;52;0;51;3
WireConnection;52;1;51;4
WireConnection;53;0;51;1
WireConnection;53;1;51;2
WireConnection;54;0;53;0
WireConnection;54;1;52;0
WireConnection;71;0;54;0
WireConnection;72;0;71;0
WireConnection;66;1;72;0
WireConnection;69;0;54;0
WireConnection;87;0;88;0
WireConnection;87;1;66;0
WireConnection;70;0;69;0
WireConnection;67;0;68;0
WireConnection;67;1;87;0
WireConnection;64;1;70;0
WireConnection;90;0;89;0
WireConnection;90;1;63;0
WireConnection;13;0;67;0
WireConnection;74;0;73;0
WireConnection;74;1;13;1
WireConnection;65;0;64;0
WireConnection;65;1;90;0
WireConnection;77;0;65;0
WireConnection;14;0;74;0
WireConnection;14;1;13;2
WireConnection;14;2;13;3
WireConnection;46;0;54;0
WireConnection;57;1;54;0
WireConnection;82;0;81;0
WireConnection;82;3;80;0
WireConnection;47;1;46;0
WireConnection;47;5;45;0
WireConnection;78;0;79;0
WireConnection;78;1;77;1
WireConnection;85;0;14;0
WireConnection;83;0;85;0
WireConnection;83;1;82;0
WireConnection;50;0;48;0
WireConnection;50;2;49;0
WireConnection;50;3;47;0
WireConnection;50;4;49;0
WireConnection;60;0;58;0
WireConnection;60;1;57;0
WireConnection;76;0;78;0
WireConnection;76;1;77;2
WireConnection;76;2;77;3
WireConnection;61;0;59;0
WireConnection;61;1;57;4
WireConnection;0;0;83;0
WireConnection;0;1;50;0
WireConnection;0;2;76;0
WireConnection;0;3;60;0
WireConnection;0;4;61;0
ASEEND*/
//CHKSM=D63E1B30A433C297EFAE0DDD6596E7765C653F94