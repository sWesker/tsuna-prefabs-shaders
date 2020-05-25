// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Tsuna/Moving Band FX"
{
	Properties
	{
		[Header(Shader by tsuna vr)][Header(Discord bDWEYUw)][Header(Visit for commissions and free stuff)][Space(25)][Toggle(_)]_ThanksforusingmyShader1("Thanks for using my Shader!", Float) = 0
		[SingleLineTexture][Header(Main)]_MainTex("Albedo Map", 2D) = "white" {}
		[HDR]_Color("Color", Color) = (0,0,0,0)
		_Clip("Clip", Range( 0 , 1)) = 0.5
		[SingleLineTexture]_MetallicGlossMap("Metallic Map", 2D) = "white" {}
		_Metaliic("Metallic Slider", Range( 0 , 1)) = 0
		_Glossiness("Smoothness Slider", Range( 0 , 1)) = 0
		[Toggle(_)]_UseNormalMap("Use Normal Map", Float) = 0
		[Normal][SingleLineTexture]_BumpMap("Normal Map", 2D) = "bump" {}
		_NormalMapSlider("Normal Map Slider", Range( 0 , 5)) = 1
		[SingleLineTexture]_EmissionMap("Emission Map", 2D) = "white" {}
		[HDR]_EmissionColor("Emission Color", Color) = (0,0,0,0)
		_TilingandOffset("Tiling and Offset", Vector) = (1,1,0,0)
		[Header(Movement)]_SpeedX("Speed X", Range( -2 , 2)) = 1
		_SpeedY("Speed Y", Range( -2 , 2)) = 1
		[Header(Chroma)]_Speed("Speed", Range( 0 , 0.25)) = 1
		[Toggle(_)]_ToggleAlbedoChroma("Toggle Albedo Chroma", Float) = 0
		[Toggle(_)]_ToggleEmissionChroma("Toggle Emission Chroma", Float) = 0
		[Header(Options)][Toggle(_)]_UseAlbedoasEmission("Use Albedo as Emission", Float) = 0
		[Header(Culling)]_BackfaceDimming("Backface Dimming", Range( 0 , 1)) = 0
		_Cull("Cull Mode ( 0 = None, 1 = Front, 2 = Back)", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "AlphaTest+0" "IsEmissive" = "true"  }
		Cull [_Cull]
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
			half ASEVFace : VFACE;
		};

		uniform float _Cull;
		uniform float _Clip;
		uniform float _ThanksforusingmyShader1;
		uniform float _UseNormalMap;
		uniform float _NormalMapSlider;
		uniform sampler2D _BumpMap;
		uniform float4 _TilingandOffset;
		uniform float _SpeedX;
		uniform float _SpeedY;
		uniform float _ToggleAlbedoChroma;
		uniform sampler2D _MainTex;
		uniform float4 _Color;
		uniform float _Speed;
		uniform float _BackfaceDimming;
		uniform float _UseAlbedoasEmission;
		uniform float _ToggleEmissionChroma;
		uniform sampler2D _EmissionMap;
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


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 _Vector0 = float3(0,0,1);
			float2 appendResult33 = (float2(_TilingandOffset.x , _TilingandOffset.y));
			float mulTime8 = _Time.y * _SpeedX;
			float mulTime14 = _Time.y * _SpeedY;
			float2 appendResult32 = (float2(( _TilingandOffset.z + mulTime8 ) , ( _TilingandOffset.w + mulTime14 )));
			float2 uv_TexCoord34 = i.uv_texcoord * appendResult33 + appendResult32;
			float3 ifLocalVar46 = 0;
			if( _UseNormalMap == 1.0 )
				ifLocalVar46 = UnpackScaleNormal( tex2D( _BumpMap, uv_TexCoord34 ), _NormalMapSlider );
			else
				ifLocalVar46 = _Vector0;
			o.Normal = ifLocalVar46;
			float4 tex2DNode1 = tex2D( _MainTex, uv_TexCoord34 );
			float4 temp_output_3_0 = ( tex2DNode1 * _Color );
			float mulTime28 = _Time.y * _Speed;
			float3 hsvTorgb3_g1 = HSVToRGB( float3(mulTime28,1.0,1.0) );
			float3 temp_output_25_6 = hsvTorgb3_g1;
			float4 ifLocalVar23 = 0;
			if( _ToggleAlbedoChroma == 1.0 )
				ifLocalVar23 = ( float4( temp_output_25_6 , 0.0 ) * temp_output_3_0 );
			else
				ifLocalVar23 = temp_output_3_0;
			float temp_output_20_0 = (_BackfaceDimming + (i.ASEVFace - -1.0) * (1.0 - _BackfaceDimming) / (1.0 - -1.0));
			float4 temp_output_22_0 = ( ifLocalVar23 * temp_output_20_0 );
			float4 clampResult64 = clamp( temp_output_22_0 , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
			o.Albedo = clampResult64.rgb;
			float4 temp_output_55_0 = ( tex2D( _EmissionMap, uv_TexCoord34 ) * _EmissionColor );
			float4 ifLocalVar58 = 0;
			if( _ToggleEmissionChroma == 1.0 )
				ifLocalVar58 = ( temp_output_55_0 * float4( temp_output_25_6 , 0.0 ) );
			else
				ifLocalVar58 = temp_output_55_0;
			float4 temp_output_56_0 = ( ifLocalVar23 * ifLocalVar58 );
			float4 ifLocalVar60 = 0;
			if( _UseAlbedoasEmission == 1.0 )
				ifLocalVar60 = temp_output_22_0;
			else
				ifLocalVar60 = temp_output_56_0;
			float4 clampResult63 = clamp( ( ifLocalVar60 * temp_output_20_0 ) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
			o.Emission = clampResult63.rgb;
			float4 tex2DNode44 = tex2D( _MetallicGlossMap, uv_TexCoord34 );
			o.Metallic = ( _Metaliic * tex2DNode44 ).r;
			o.Smoothness = ( _Glossiness * tex2DNode44.a );
			o.Alpha = 1;
			clip( tex2DNode1.a - _Clip );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18100
193.6;172;2608;1494;1074.436;660.1487;1;True;False
Node;AmplifyShaderEditor.RangedFloatNode;11;-2855.608,863.5547;Float;False;Property;_SpeedX;Speed X;13;0;Create;True;0;0;False;1;Header(Movement);False;1;1;-2;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-2861.135,1000.161;Float;False;Property;_SpeedY;Speed Y;14;0;Create;True;0;0;False;0;False;1;1;-2;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;31;-2509.065,586.3723;Inherit;False;Property;_TilingandOffset;Tiling and Offset;12;0;Create;True;0;0;False;0;False;1,1,0,0;5,5,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;8;-2477.477,874.9304;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;14;-2466.135,1009.161;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;51;-2157.214,822.8207;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;49;-2159.858,720.3677;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;33;-2005.425,598.6901;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;32;-1984.425,766.6904;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;30;-1214.97,421.8889;Inherit;False;Property;_Speed;Speed;15;0;Create;True;0;0;False;1;Header(Chroma);False;1;0.25;0;0.25;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;34;-1820.425,645.6902;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;6;-860.6686,71.56152;Float;False;Property;_Color;Color;2;1;[HDR];Create;True;0;0;False;0;False;0,0,0,0;1,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;54;207.9169,535.885;Float;False;Property;_EmissionColor;Emission Color;11;1;[HDR];Create;True;0;0;False;0;False;0,0,0,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;28;-880.7776,320.2378;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-903.1818,-159.162;Inherit;True;Property;_MainTex;Albedo Map;1;1;[SingleLineTexture];Create;False;0;0;False;1;Header(Main);False;-1;None;6ad8460d342dd8a4b8e2ed59beb6ba32;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;53;165.4037,305.1615;Inherit;True;Property;_EmissionMap;Emission Map;10;1;[SingleLineTexture];Create;True;0;0;False;0;False;-1;None;6ad8460d342dd8a4b8e2ed59beb6ba32;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;-493.3585,-109.9835;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;55;498.7355,323.1664;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;25;-661.2078,350.4996;Inherit;False;Simple HUE;-1;;1;32abb5f0db087604486c2db83a2e817a;0;1;1;FLOAT;0;False;4;FLOAT3;6;FLOAT;7;FLOAT;5;FLOAT;8
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;57;758.9086,364.2466;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FaceVariableNode;21;-605.5581,-441.403;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-774.9941,-331.3537;Inherit;False;Property;_BackfaceDimming;Backface Dimming;19;0;Create;True;0;0;False;1;Header(Culling);False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-491.2201,-210.4823;Inherit;False;Property;_ToggleAlbedoChroma;Toggle Albedo Chroma;16;0;Create;True;0;0;False;1;Toggle(_);False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-233.3446,72.34875;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;59;489.6838,200.5034;Inherit;False;Property;_ToggleEmissionChroma;Toggle Emission Chroma;17;0;Create;True;0;0;False;1;Toggle(_);False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;58;953.9084,178.2465;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;1;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCRemapNode;20;-427.2088,-392.5872;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;0.1;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;23;-40.62026,-117.0824;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;1;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;876.2645,-56.45533;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;56;1201.714,117.5054;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;61;1119.958,-118.1093;Inherit;False;Property;_UseAlbedoasEmission;Use Albedo as Emission;18;0;Create;True;0;0;False;2;Header(Options);Toggle(_);False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;38;-904.5606,1183.078;Inherit;False;Property;_NormalMapSlider;Normal Map Slider;9;0;Create;True;0;0;False;0;False;1;1;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;60;1459.183,41.63385;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;1;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;37;-707.8997,799.6908;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector3Node;40;-302.4044,1352.981;Inherit;False;Constant;_Vector0;Vector 0;11;0;Create;True;0;0;False;0;False;0,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;42;-435.2237,513.1855;Inherit;False;Property;_Metaliic;Metallic Slider;5;0;Create;False;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;39;-431.357,810.092;Inherit;False;Property;_Glossiness;Smoothness Slider;6;0;Create;False;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;41;-435.6936,1137.078;Inherit;True;Property;_BumpMap;Normal Map;8;2;[Normal];[SingleLineTexture];Create;False;0;0;False;0;False;-1;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;0;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;62;1732.872,3.376205;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;44;-448.7241,609.5528;Inherit;True;Property;_MetallicGlossMap;Metallic Map;4;1;[SingleLineTexture];Create;False;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;43;-335.7532,1049.972;Inherit;False;Property;_UseNormalMap;Use Normal Map;7;0;Create;True;0;0;False;1;Toggle(_);False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;63;1895.564,36.85135;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;64;1896.564,-96.14865;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;45;-46.30099,710.4988;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;26;374.9002,-284.4877;Inherit;False;Property;_Cull;Cull Mode ( 0 = None, 1 = Front, 2 = Back);20;0;Create;False;0;0;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;27;378.9772,-369.9063;Inherit;False;Property;_Clip;Clip;3;0;Create;True;0;0;True;0;False;0.5;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;46;-93.18022,1202.343;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;47;-45.08578,553.0907;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;65;1736.563,501.8516;Inherit;False;Property;_ThanksforusingmyShader1;Thanks for using my Shader!;0;0;Create;True;0;0;True;5;Header(Shader by tsuna vr);Header(Discord bDWEYUw);Header(Visit for commissions and free stuff);Space(25);Toggle(_);False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2091.204,-18.09905;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Tsuna/Moving Band FX;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Masked;0.5;True;True;0;False;TransparentCutout;;AlphaTest;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;True;26;-1;0;True;27;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;8;0;11;0
WireConnection;14;0;15;0
WireConnection;51;0;31;4
WireConnection;51;1;14;0
WireConnection;49;0;31;3
WireConnection;49;1;8;0
WireConnection;33;0;31;1
WireConnection;33;1;31;2
WireConnection;32;0;49;0
WireConnection;32;1;51;0
WireConnection;34;0;33;0
WireConnection;34;1;32;0
WireConnection;28;0;30;0
WireConnection;1;1;34;0
WireConnection;53;1;34;0
WireConnection;3;0;1;0
WireConnection;3;1;6;0
WireConnection;55;0;53;0
WireConnection;55;1;54;0
WireConnection;25;1;28;0
WireConnection;57;0;55;0
WireConnection;57;1;25;6
WireConnection;29;0;25;6
WireConnection;29;1;3;0
WireConnection;58;0;59;0
WireConnection;58;2;55;0
WireConnection;58;3;57;0
WireConnection;58;4;55;0
WireConnection;20;0;21;0
WireConnection;20;3;19;0
WireConnection;23;0;24;0
WireConnection;23;2;3;0
WireConnection;23;3;29;0
WireConnection;23;4;3;0
WireConnection;22;0;23;0
WireConnection;22;1;20;0
WireConnection;56;0;23;0
WireConnection;56;1;58;0
WireConnection;60;0;61;0
WireConnection;60;2;56;0
WireConnection;60;3;22;0
WireConnection;60;4;56;0
WireConnection;37;0;34;0
WireConnection;41;1;37;0
WireConnection;41;5;38;0
WireConnection;62;0;60;0
WireConnection;62;1;20;0
WireConnection;44;1;34;0
WireConnection;63;0;62;0
WireConnection;64;0;22;0
WireConnection;45;0;39;0
WireConnection;45;1;44;4
WireConnection;46;0;43;0
WireConnection;46;2;40;0
WireConnection;46;3;41;0
WireConnection;46;4;40;0
WireConnection;47;0;42;0
WireConnection;47;1;44;0
WireConnection;0;0;64;0
WireConnection;0;1;46;0
WireConnection;0;2;63;0
WireConnection;0;3;47;0
WireConnection;0;4;45;0
WireConnection;0;10;1;4
ASEEND*/
//CHKSM=58712999685392EDDB983D71D3B181E3705395D1