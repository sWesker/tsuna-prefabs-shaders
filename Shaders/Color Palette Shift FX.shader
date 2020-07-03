// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Tsuna/Color Palette Shift FX"
{
	Properties
	{
		[Header(Shader by tsuna vr)][Header(Discord bDWEYUw)][Header(Visit for commissions and free stuff)][Space(25)][Toggle(_)]_ThanksforusingmyShader1("Thanks for using my Shader!", Float) = 0
		[SingleLineTexture][Header(Main)]_MainTex("Albedo Map", 2D) = "white" {}
		_Color("Albedo Color", Color) = (1,1,1,0)
		[SingleLineTexture]_MetallicGlossMap("Metallic Map", 2D) = "white" {}
		_Metaliic("Metallic Slider", Range( 0 , 1)) = 0
		_Glossiness("Smoothness Slider", Range( 0 , 1)) = 0
		[Toggle(_)]_UseNormalMap("Use Normal Map", Float) = 0
		[Normal][SingleLineTexture]_BumpMap("Normal Map", 2D) = "bump" {}
		_NormalMapSlider("Normal Map Slider", Range( 0 , 5)) = 1
		[SingleLineTexture]_EmissionMap("Emission Map", 2D) = "black" {}
		[HDR]_EmissionColor("Emission Color", Color) = (0,0,0,0)
		_TilingandOffset("Tiling and Offset", Vector) = (1,1,0,0)
		[Header(Palette)]_Color1("Color 1", Color) = (0,0,0,0)
		_Color2("Color 2", Color) = (1,1,1,0)
		_Speed("Speed", Range( 0 , 4)) = 0
		[Toggle(_)]_ToggleMainShift("Toggle Main Shift", Float) = 0
		[Toggle(_)]_ToggleEmissionShift("Toggle Emission Shift", Float) = 0
		[Header(Chroma)]_ChromaSpeed("Speed", Range( 0 , 2)) = 0
		[Toggle(_)]_ChromaMainShift("Chroma Main Shift", Float) = 0
		[Toggle(_)]_ChromaEmissionShift("Chroma Emission Shift", Float) = 0
		[Header(Culling)]_CullMode1("Cull Mode ( 0 = None, 1 = Front, 2 = Back)", Float) = 0
		_BackfaceDimming("Backface Dimming", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull [_CullMode1]
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

		uniform float _CullMode1;
		uniform float _ThanksforusingmyShader1;
		uniform float _UseNormalMap;
		uniform float _NormalMapSlider;
		uniform sampler2D _BumpMap;
		uniform float4 _TilingandOffset;
		uniform float _ToggleMainShift;
		uniform float4 _Color;
		uniform sampler2D _MainTex;
		uniform float _ChromaMainShift;
		uniform float4 _Color1;
		uniform float4 _Color2;
		uniform float _Speed;
		uniform float _ChromaSpeed;
		uniform float _BackfaceDimming;
		uniform float _ToggleEmissionShift;
		uniform sampler2D _EmissionMap;
		uniform float4 _EmissionColor;
		uniform float _ChromaEmissionShift;
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
			float2 appendResult81 = (float2(_TilingandOffset.x , _TilingandOffset.y));
			float2 appendResult82 = (float2(_TilingandOffset.z , _TilingandOffset.w));
			float2 uv_TexCoord79 = i.uv_texcoord * appendResult81 + appendResult82;
			float3 ifLocalVar38 = 0;
			if( _UseNormalMap == 1.0 )
				ifLocalVar38 = UnpackScaleNormal( tex2D( _BumpMap, uv_TexCoord79 ), _NormalMapSlider );
			else
				ifLocalVar38 = _Vector0;
			o.Normal = ifLocalVar38;
			float4 temp_output_25_0 = ( _Color * tex2D( _MainTex, uv_TexCoord79 ) );
			float mulTime28 = _Time.y * _Speed;
			float4 lerpResult23 = lerp( _Color1 , _Color2 , (0.0 + (sin( mulTime28 ) - -1.0) * (1.0 - 0.0) / (1.0 - -1.0)));
			float mulTime43 = _Time.y * _ChromaSpeed;
			float3 hsvTorgb3_g1 = HSVToRGB( float3(mulTime43,1.0,1.0) );
			float3 temp_output_41_6 = hsvTorgb3_g1;
			float4 ifLocalVar45 = 0;
			if( _ChromaMainShift == 1.0 )
				ifLocalVar45 = float4( temp_output_41_6 , 0.0 );
			else
				ifLocalVar45 = lerpResult23;
			float4 ifLocalVar55 = 0;
			if( _ToggleMainShift == 1.0 )
				ifLocalVar55 = ( temp_output_25_0 * ifLocalVar45 );
			else
				ifLocalVar55 = temp_output_25_0;
			float4 clampResult95 = clamp( ( ifLocalVar55 * (_BackfaceDimming + (i.ASEVFace - -1.0) * (1.0 - _BackfaceDimming) / (1.0 - -1.0)) ) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
			o.Albedo = clampResult95.rgb;
			float4 temp_output_26_0 = ( tex2D( _EmissionMap, uv_TexCoord79 ) * _EmissionColor );
			float4 temp_output_59_0 = ( lerpResult23 * temp_output_26_0 );
			float4 ifLocalVar51 = 0;
			if( _ChromaEmissionShift == 1.0 )
				ifLocalVar51 = ( temp_output_26_0 * float4( temp_output_41_6 , 0.0 ) );
			else
				ifLocalVar51 = temp_output_59_0;
			float4 ifLocalVar57 = 0;
			if( _ToggleEmissionShift == 1.0 )
				ifLocalVar57 = ifLocalVar51;
			else
				ifLocalVar57 = temp_output_26_0;
			float4 clampResult94 = clamp( ifLocalVar57 , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
			o.Emission = clampResult94.rgb;
			float4 tex2DNode61 = tex2D( _MetallicGlossMap, uv_TexCoord79 );
			o.Metallic = ( _Metaliic * tex2DNode61 ).r;
			o.Smoothness = ( _Glossiness * tex2DNode61.a );
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18100
250.4;103.2;2412;1407;4381.697;1909.487;3.181545;True;False
Node;AmplifyShaderEditor.Vector4Node;80;-964.1041,294.1245;Inherit;False;Property;_TilingandOffset;Tiling and Offset;11;0;Create;True;0;0;False;0;False;1,1,0,0;1,1,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;11;-2848.672,-417.3738;Float;False;Property;_Speed;Speed;14;0;Create;True;0;0;False;0;False;0;0;0;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;81;-693.1041,255.1245;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;82;-696.1041,408.1245;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;28;-2461.011,-546.4233;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;79;-508.1041,302.1245;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;87;-317.2417,248.6964;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;42;-2227.456,-974.0718;Inherit;False;Property;_ChromaSpeed;Speed;17;0;Create;False;0;0;False;1;Header(Chroma);False;0;0;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;29;-2233.011,-544.4233;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;86;-226.2417,206.6964;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;21;-2473.131,-912.5893;Float;False;Property;_Color1;Color 1;12;0;Create;True;0;0;False;1;Header(Palette);False;0,0,0,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;22;-2469.524,-731.5177;Float;False;Property;_Color2;Color 2;13;0;Create;True;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;50;-2184.894,-776.8923;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleTimeNode;43;-1861.309,-909.4609;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;85;-1474.879,-29.79145;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TFHCRemapNode;31;-2007.885,-549.2682;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;84;-1502.27,-130.2257;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;23;-1653.195,-691.6765;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1;-1240.656,-626.0953;Inherit;True;Property;_MainTex;Albedo Map;1;1;[SingleLineTexture];Create;False;0;0;False;1;Header(Main);False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;32;-1143.621,-228.7663;Inherit;False;Property;_EmissionColor;Emission Color;10;1;[HDR];Create;True;0;0;False;0;False;0,0,0,0;1,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;33;-1137.323,-1015.233;Inherit;False;Property;_Color;Albedo Color;2;0;Create;False;0;0;False;0;False;1,1,1,0;1,0,0,0.5019608;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;46;-1648,-1024;Inherit;False;Property;_ChromaMainShift;Chroma Main Shift;18;0;Create;True;0;0;False;1;Toggle(_);False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;41;-1647.595,-925.2122;Inherit;True;Simple HUE;-1;;1;32abb5f0db087604486c2db83a2e817a;0;1;1;FLOAT;0;False;4;FLOAT3;6;FLOAT;7;FLOAT;5;FLOAT;8
Node;AmplifyShaderEditor.SamplerNode;7;-1230.463,-429.7571;Inherit;True;Property;_EmissionMap;Emission Map;9;1;[SingleLineTexture];Create;False;0;0;False;0;False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;54;-1249.896,-35.95081;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-863.5823,-681.2032;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ConditionalIfNode;45;-1136,-832;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;1;False;2;COLOR;0,0,0,0;False;3;FLOAT3;0,0,0;False;4;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;-873.2488,-356.2782;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;90;-0.9118342,-898.3193;Inherit;False;Property;_BackfaceDimming;Backface Dimming;21;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;56;-134.8557,-700.5552;Inherit;False;Property;_ToggleMainShift;Toggle Main Shift;15;0;Create;True;0;0;False;1;Toggle(_);False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;60;-505.58,-744.8035;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;59;-482.5311,-396.8232;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FaceVariableNode;91;168.5242,-1008.368;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;52;-800.1087,-505.9614;Inherit;False;Property;_ChromaEmissionShift;Chroma Emission Shift;19;0;Create;True;0;0;False;1;Toggle(_);False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;53;-472.0619,-190.7571;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCRemapNode;89;346.8732,-959.5529;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;0.1;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;51;-147.7491,-461.776;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;1;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;83;-191.5258,591.4158;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;34;-52.21659,785.8587;Inherit;False;Property;_NormalMapSlider;Normal Map Slider;8;0;Create;True;0;0;False;0;False;1;1;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;58;-146.0422,-164.5254;Inherit;False;Property;_ToggleEmissionShift;Toggle Emission Shift;16;0;Create;True;0;0;False;1;Toggle(_);False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;55;261.6867,-588.5078;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;1;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ConditionalIfNode;57;270.5231,-317.0975;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;1;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;61;-3.662189,136.0107;Inherit;True;Property;_MetallicGlossMap;Metallic Map;3;1;[SingleLineTexture];Create;False;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;36;260.0808,739.8588;Inherit;True;Property;_BumpMap;Normal Map;7;2;[Normal];[SingleLineTexture];Create;False;0;0;False;0;False;-1;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;0;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;64;12.70486,336.5497;Inherit;False;Property;_Glossiness;Smoothness Slider;5;0;Create;False;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;35;393.3701,955.7621;Inherit;False;Constant;_Vector0;Vector 0;11;0;Create;True;0;0;False;0;False;0,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;92;657.1061,-782.0599;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;37;360.0214,652.7527;Inherit;False;Property;_UseNormalMap;Use Normal Map;6;0;Create;True;0;0;False;1;Toggle(_);False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;65;9.838226,40.64343;Inherit;False;Property;_Metaliic;Metallic Slider;4;0;Create;False;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;94;594.833,-208.0482;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;95;775.244,-581.1862;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ConditionalIfNode;38;602.5943,805.1236;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;76;398.761,236.9567;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;93;399.9762,79.54861;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;96;1028.242,-614.1875;Inherit;False;Property;_ThanksforusingmyShader1;Thanks for using my Shader!;0;0;Create;True;0;0;True;5;Header(Shader by tsuna vr);Header(Discord bDWEYUw);Header(Visit for commissions and free stuff);Space(25);Toggle(_);False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;40;886.6642,232.0624;Inherit;False;Property;_CullMode1;Cull Mode ( 0 = None, 1 = Front, 2 = Back);20;0;Create;False;0;0;True;1;Header(Culling);False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;906.7217,-234.0449;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Tsuna/Color Palette Shift FX;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;True;40;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;81;0;80;1
WireConnection;81;1;80;2
WireConnection;82;0;80;3
WireConnection;82;1;80;4
WireConnection;28;0;11;0
WireConnection;79;0;81;0
WireConnection;79;1;82;0
WireConnection;87;0;79;0
WireConnection;29;0;28;0
WireConnection;86;0;79;0
WireConnection;50;0;21;0
WireConnection;43;0;42;0
WireConnection;85;0;87;0
WireConnection;31;0;29;0
WireConnection;84;0;86;0
WireConnection;23;0;50;0
WireConnection;23;1;22;0
WireConnection;23;2;31;0
WireConnection;1;1;84;0
WireConnection;41;1;43;0
WireConnection;7;1;85;0
WireConnection;54;0;41;6
WireConnection;25;0;33;0
WireConnection;25;1;1;0
WireConnection;45;0;46;0
WireConnection;45;2;23;0
WireConnection;45;3;41;6
WireConnection;45;4;23;0
WireConnection;26;0;7;0
WireConnection;26;1;32;0
WireConnection;60;0;25;0
WireConnection;60;1;45;0
WireConnection;59;0;23;0
WireConnection;59;1;26;0
WireConnection;53;0;26;0
WireConnection;53;1;54;0
WireConnection;89;0;91;0
WireConnection;89;3;90;0
WireConnection;51;0;52;0
WireConnection;51;2;59;0
WireConnection;51;3;53;0
WireConnection;51;4;59;0
WireConnection;83;0;79;0
WireConnection;55;0;56;0
WireConnection;55;2;25;0
WireConnection;55;3;60;0
WireConnection;55;4;25;0
WireConnection;57;0;58;0
WireConnection;57;2;26;0
WireConnection;57;3;51;0
WireConnection;57;4;26;0
WireConnection;61;1;79;0
WireConnection;36;1;83;0
WireConnection;36;5;34;0
WireConnection;92;0;55;0
WireConnection;92;1;89;0
WireConnection;94;0;57;0
WireConnection;95;0;92;0
WireConnection;38;0;37;0
WireConnection;38;2;35;0
WireConnection;38;3;36;0
WireConnection;38;4;35;0
WireConnection;76;0;64;0
WireConnection;76;1;61;4
WireConnection;93;0;65;0
WireConnection;93;1;61;0
WireConnection;0;0;95;0
WireConnection;0;1;38;0
WireConnection;0;2;94;0
WireConnection;0;3;93;0
WireConnection;0;4;76;0
ASEEND*/
//CHKSM=996980CB452614ED259B430AF4DC13CBBDAB8A47