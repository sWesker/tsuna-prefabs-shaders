// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Tsuna/Hue Shift FX"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_MainTex("Main Tex", 2D) = "white" {}
		_EmissionMap("EmissionMap", 2D) = "black" {}
		_MetallicGlossMap("MetallicGlossMap", 2D) = "white" {}
		_SmoothnessMap("SmoothnessMap", 2D) = "white" {}
		_PulseSpeed("Pulse Speed", Range( 0 , 2)) = 0
		_ColorSpeed("Color Speed", Range( 0 , 2)) = 0
		_Dimming("Dimming", Range( 0 , 1)) = 0
		_Strength("Strength", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "AlphaTest+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float _PulseSpeed;
		uniform float _Dimming;
		uniform float _ColorSpeed;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform float _Strength;
		uniform sampler2D _EmissionMap;
		uniform float4 _EmissionMap_ST;
		uniform sampler2D _MetallicGlossMap;
		uniform float4 _MetallicGlossMap_ST;
		uniform sampler2D _SmoothnessMap;
		uniform float4 _SmoothnessMap_ST;
		uniform float _Cutoff = 0.5;


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
			float temp_output_40_0 = sin( ( _PulseSpeed * _Time.y ) );
			float temp_output_41_0 = (_Dimming + (temp_output_40_0 - -1.0) * (1.0 - _Dimming) / (1.0 - -1.0));
			float temp_output_33_0 = frac( ( _ColorSpeed * _Time.y ) );
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float4 tex2DNode1 = tex2D( _MainTex, uv_MainTex );
			float3 hsvTorgb13 = RGBToHSV( tex2DNode1.rgb );
			float3 hsvTorgb14 = HSVToRGB( float3(( temp_output_33_0 + hsvTorgb13 ).x,hsvTorgb13.y,hsvTorgb13.z) );
			o.Albedo = ( temp_output_41_0 * hsvTorgb14 );
			float2 uv_EmissionMap = i.uv_texcoord * _EmissionMap_ST.xy + _EmissionMap_ST.zw;
			float3 hsvTorgb15 = RGBToHSV( tex2D( _EmissionMap, uv_EmissionMap ).rgb );
			float3 hsvTorgb17 = HSVToRGB( float3(( temp_output_33_0 + hsvTorgb15 ).x,hsvTorgb15.y,hsvTorgb15.z) );
			o.Emission = ( _Strength * hsvTorgb17 * temp_output_41_0 );
			float2 uv_MetallicGlossMap = i.uv_texcoord * _MetallicGlossMap_ST.xy + _MetallicGlossMap_ST.zw;
			o.Metallic = tex2D( _MetallicGlossMap, uv_MetallicGlossMap ).r;
			float2 uv_SmoothnessMap = i.uv_texcoord * _SmoothnessMap_ST.xy + _SmoothnessMap_ST.zw;
			o.Smoothness = tex2D( _SmoothnessMap, uv_SmoothnessMap ).r;
			o.Alpha = 1;
			clip( tex2DNode1.a - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17900
227.2;241.6;1974;1251;2437.53;1027.11;1.840549;True;False
Node;AmplifyShaderEditor.RangedFloatNode;11;-2144.922,-1029.263;Float;False;Property;_ColorSpeed;Color Speed;6;0;Create;True;0;0;False;0;0;0.264;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;28;-2076.319,-931.8683;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;39;-1812.711,-1034.575;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;37;-2145.01,-1119.375;Float;False;Property;_PulseSpeed;Pulse Speed;5;0;Create;True;0;0;False;0;0;0;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-1697.43,-550.7773;Inherit;True;Property;_MainTex;Main Tex;1;0;Create;True;0;0;False;0;-1;None;837c514d022dab74dae1a203af48979d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;36;-1769.956,-968.7968;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;7;-1631.206,127.8067;Inherit;True;Property;_EmissionMap;EmissionMap;2;0;Create;True;0;0;False;0;-1;None;862cde4a6247b0d4aa89c99e6629ffe2;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RGBToHSVNode;15;-1262.131,132.9002;Float;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RGBToHSVNode;13;-1333.74,-544.3761;Float;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;-1415.711,-1115.575;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;33;-1575.261,-969.1135;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;40;-1211.102,-1116.837;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;34;-1002.026,-632.5149;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;42;-1276.102,-1221.359;Float;False;Property;_Dimming;Dimming;7;0;Create;True;0;0;False;0;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;35;-922.8531,102.7864;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-786.9111,-52.69498;Float;False;Property;_Strength;Strength;8;0;Create;True;0;0;False;0;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.HSVToRGBNode;14;-793.1876,-460.0229;Float;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.HSVToRGBNode;17;-743.3243,155.4923;Float;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TFHCRemapNode;41;-844.2328,-1116.783;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;43;-786.3269,-732.2637;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;9;160.042,424.2698;Inherit;True;Property;_MetallicGlossMap;MetallicGlossMap;3;0;Create;True;0;0;False;0;-1;None;b5a495c41afe66843adf04c568f3d796;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;-333.8568,-678.4854;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;-300.9686,35.1364;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;44;157.3596,625.4845;Inherit;True;Property;_SmoothnessMap;SmoothnessMap;4;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;918.0816,-4.84771;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Tsuna/Hue Shift FX;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Masked;0.5;True;True;0;False;TransparentCutout;;AlphaTest;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;39;0;28;0
WireConnection;36;0;11;0
WireConnection;36;1;28;0
WireConnection;15;0;7;0
WireConnection;13;0;1;0
WireConnection;38;0;37;0
WireConnection;38;1;39;0
WireConnection;33;0;36;0
WireConnection;40;0;38;0
WireConnection;34;0;33;0
WireConnection;34;1;13;0
WireConnection;35;0;33;0
WireConnection;35;1;15;0
WireConnection;14;0;34;0
WireConnection;14;1;13;2
WireConnection;14;2;13;3
WireConnection;17;0;35;0
WireConnection;17;1;15;2
WireConnection;17;2;15;3
WireConnection;41;0;40;0
WireConnection;41;3;42;0
WireConnection;43;0;40;0
WireConnection;26;0;41;0
WireConnection;26;1;14;0
WireConnection;19;0;20;0
WireConnection;19;1;17;0
WireConnection;19;2;41;0
WireConnection;0;0;26;0
WireConnection;0;2;19;0
WireConnection;0;3;9;0
WireConnection;0;4;44;0
WireConnection;0;10;1;4
ASEEND*/
//CHKSM=73E30973A22A2FCB2031F05A614D7051D39B4696