// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Tsuna/Lerp Pulse FX"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.36
		_EmissionMap("EmissionMap", 2D) = "white" {}
		_MainTex("MainTex", 2D) = "white" {}
		_ReplacementEmissionMap("ReplacementEmissionMap", 2D) = "white" {}
		_ReplacementMainTex("ReplacementMainTex", 2D) = "white" {}
		_Speed("Speed", Range( 0 , 1)) = 0.5
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

		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform sampler2D _ReplacementMainTex;
		uniform float4 _ReplacementMainTex_ST;
		uniform float _Speed;
		uniform sampler2D _EmissionMap;
		uniform float4 _EmissionMap_ST;
		uniform sampler2D _ReplacementEmissionMap;
		uniform float4 _ReplacementEmissionMap_ST;
		uniform float _Cutoff = 0.36;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float4 tex2DNode2 = tex2D( _MainTex, uv_MainTex );
			float2 uv_ReplacementMainTex = i.uv_texcoord * _ReplacementMainTex_ST.xy + _ReplacementMainTex_ST.zw;
			float4 tex2DNode3 = tex2D( _ReplacementMainTex, uv_ReplacementMainTex );
			float clampResult11 = clamp( (-0.25 + (_SinTime.w - -1.0) * (1.25 - -0.25) / (1.0 - -1.0)) , 0.0 , 1.0 );
			float temp_output_5_0 = ( clampResult11 * _Speed );
			float4 lerpResult7 = lerp( tex2DNode2 , tex2DNode3 , temp_output_5_0);
			o.Albedo = lerpResult7.rgb;
			float2 uv_EmissionMap = i.uv_texcoord * _EmissionMap_ST.xy + _EmissionMap_ST.zw;
			float2 uv_ReplacementEmissionMap = i.uv_texcoord * _ReplacementEmissionMap_ST.xy + _ReplacementEmissionMap_ST.zw;
			float4 lerpResult15 = lerp( tex2D( _EmissionMap, uv_EmissionMap ) , tex2D( _ReplacementEmissionMap, uv_ReplacementEmissionMap ) , temp_output_5_0);
			o.Emission = lerpResult15.rgb;
			o.Alpha = 1;
			float lerpResult8 = lerp( tex2DNode2.a , tex2DNode3.a , temp_output_5_0);
			clip( lerpResult8 - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17500
288;379;2317;1734;1141.5;333;1;True;False
Node;AmplifyShaderEditor.SinTimeNode;4;-1067.5,236;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;10;-836.5,217;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;-0.25;False;4;FLOAT;1.25;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-721.5,418;Inherit;False;Property;_Speed;Speed;5;0;Create;True;0;0;False;0;0.5;0.882;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;11;-592.5,258;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-723.5,-218;Inherit;True;Property;_MainTex;MainTex;2;0;Create;True;0;0;False;0;-1;9eef3ef150142cb46b5e73390d2d030d;9eef3ef150142cb46b5e73390d2d030d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;13;-726.25,773.5;Inherit;True;Property;_ReplacementEmissionMap;ReplacementEmissionMap;3;0;Create;True;0;0;False;0;-1;4ddb2e078dc699149a410cd17b334756;4ddb2e078dc699149a410cd17b334756;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;14;-731.25,548.5;Inherit;True;Property;_EmissionMap;EmissionMap;1;0;Create;True;0;0;False;0;-1;9eef3ef150142cb46b5e73390d2d030d;9eef3ef150142cb46b5e73390d2d030d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;-358.5,317;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;3;-718.5,7;Inherit;True;Property;_ReplacementMainTex;ReplacementMainTex;4;0;Create;True;0;0;False;0;-1;4ddb2e078dc699149a410cd17b334756;4ddb2e078dc699149a410cd17b334756;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;15;7.75,420.5;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;8;6.5,149;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;7;4.5,-116;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;547,-37;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Tsuna/Lerp Pulse FX;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Masked;0.36;True;True;0;False;TransparentCutout;;AlphaTest;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;10;0;4;4
WireConnection;11;0;10;0
WireConnection;5;0;11;0
WireConnection;5;1;6;0
WireConnection;15;0;14;0
WireConnection;15;1;13;0
WireConnection;15;2;5;0
WireConnection;8;0;2;4
WireConnection;8;1;3;4
WireConnection;8;2;5;0
WireConnection;7;0;2;0
WireConnection;7;1;3;0
WireConnection;7;2;5;0
WireConnection;0;0;7;0
WireConnection;0;2;15;0
WireConnection;0;10;8;0
ASEEND*/
//CHKSM=B2784A464E78E433E8D97FBEB6A3D9A6B11215DD