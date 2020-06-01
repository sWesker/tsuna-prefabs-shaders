// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Tsuna/Dissolve WL"
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
		[SingleLineTexture]_EmissionMap("Emission Map", 2D) = "white" {}
		[HDR]_EmissionColor("Emission Color", Color) = (1,1,1,0)
		_TilingandOffset("Tiling and Offset", Vector) = (1,1,0,0)
		[SingleLineTexture][Header(Dissolve)]_DissolveMap("Dissolve Map", 2D) = "white" {}
		[HDR]_DissolveColor("Dissolve Color", Color) = (1,1,1,0)
		[SingleLineTexture]_DissolveRamp("Ramp", 2D) = "white" {}
		_PositionStrenght("Strength", Range( -2.5 , 2.5)) = 0.884636
		_DissolveRange("Range", Range( 1 , 10)) = 5.997281
		_Progress("Progress", Range( 0 , 1)) = 1
		[Toggle(_)]_DissolveInvert("Invert", Float) = 0
		_TODissolve("Tiling and Offset", Vector) = (1,1,0,0)
		[Toggle(_)][Header(Time)]_ToggleTime("Toggle Time", Float) = 0
		_Speed("Speed", Range( 0 , 0.25)) = 1
		[Toggle(_)][Header(Movement)]_ToggleMovement("Toggle Movement", Float) = 0
		_DissolveMovement("Movement", Vector) = (0,0,0,0)
		[Toggle(_)][Header(Direction)]_ToggleDirection("Toggle Direction", Float) = 0
		_DissolveDirection("Direction", Vector) = (0,0,0,0)
		_DissolvePosition("Position", Range( -25 , 25)) = 0.884636
		[Toggle(_)]_TogglePositionShift("Toggle Position Shift", Float) = 0
		_ShiftSpeed("Shift Speed", Range( 0 , 0.25)) = 0.1176471
		[Toggle(_)][Header(Chroma)]_ToggleChroma("Toggle Chroma", Float) = 0
		_ChromaSpeed("Speed", Range( 0 , 0.25)) = 1
		_Strength("Strength", Range( 0 , 2)) = 1
		[Header(Culling)]_BackfaceDimming("Backface Dimming", Range( 0 , 1)) = 0
		_DissolveClip("Clip", Range( 0 , 1)) = 0.5
		_Cull("Cull Mode ( 0 = None, 1 = Front, 2 = Back)", Float) = 2
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "AlphaTest+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull [_Cull]
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			half ASEVFace : VFACE;
		};

		uniform float _Cull;
		uniform float _ThanksforusingmyShader1;
		uniform float _DissolveClip;
		uniform float _UseNormalMap;
		uniform float _NormalMapSlider;
		uniform sampler2D _BumpMap;
		uniform float4 _TilingandOffset;
		uniform float4 _Color;
		uniform sampler2D _MainTex;
		uniform float _ToggleChroma;
		uniform sampler2D _DissolveRamp;
		uniform float _DissolveInvert;
		uniform float _ToggleDirection;
		uniform sampler2D _DissolveMap;
		uniform float4 _TODissolve;
		uniform float _ToggleMovement;
		uniform float2 _DissolveMovement;
		uniform float3 _DissolveDirection;
		uniform float _TogglePositionShift;
		uniform float _DissolvePosition;
		uniform float _ShiftSpeed;
		uniform float _PositionStrenght;
		uniform float _ToggleTime;
		uniform float _Progress;
		uniform float _Speed;
		uniform float _DissolveRange;
		uniform float4 _DissolveColor;
		uniform float _ChromaSpeed;
		uniform float _Strength;
		uniform float4 _EmissionColor;
		uniform sampler2D _EmissionMap;
		uniform float _BackfaceDimming;
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
			float3 _Vector2 = float3(0,0,1);
			float2 appendResult120 = (float2(_TilingandOffset.x , _TilingandOffset.y));
			float2 appendResult119 = (float2(_TilingandOffset.z , _TilingandOffset.w));
			float2 uv_TexCoord121 = i.uv_texcoord * appendResult120 + appendResult119;
			float3 ifLocalVar132 = 0;
			if( _UseNormalMap == 1.0 )
				ifLocalVar132 = UnpackScaleNormal( tex2D( _BumpMap, uv_TexCoord121 ), _NormalMapSlider );
			else
				ifLocalVar132 = _Vector2;
			o.Normal = ifLocalVar132;
			float4 tex2DNode50 = tex2D( _MainTex, uv_TexCoord121 );
			float grayscale33 = dot(float3(0,0,0), float3(0.299,0.587,0.114));
			float2 temp_cast_0 = (0.0).xx;
			float2 appendResult192 = (float2(( _Time.y * _DissolveMovement.x ) , ( _Time.y * _DissolveMovement.y )));
			float2 temp_cast_1 = (0.0).xx;
			float2 ifLocalVar187 = 0;
			if( _ToggleMovement == 1.0 )
				ifLocalVar187 = appendResult192;
			else
				ifLocalVar187 = temp_cast_0;
			float2 break190 = ifLocalVar187;
			float2 appendResult76 = (float2((i.uv_texcoord.x*_TODissolve.x + ( _TODissolve.z + break190.x )) , (i.uv_texcoord.y*_TODissolve.y + ( _TODissolve.w + break190.y ))));
			float4 tex2DNode1 = tex2D( _DissolveMap, appendResult76 );
			float4 color148 = IsGammaSpace() ? float4(0,0,0,0) : float4(0,0,0,0);
			float4 color151 = IsGammaSpace() ? float4(1,1,1,0) : float4(1,1,1,0);
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float dotResult210 = dot( ase_vertex3Pos , _DissolveDirection );
			float mulTime196 = _Time.y * _ShiftSpeed;
			float ifLocalVar201 = 0;
			if( _TogglePositionShift == 1.0 )
				ifLocalVar201 = (-3.0 + (sin( mulTime196 ) - -1.0) * (3.0 - -3.0) / (1.0 - -1.0));
			else
				ifLocalVar201 = _DissolvePosition;
			float4 lerpResult150 = lerp( color148 , color151 , ( dotResult210 - ifLocalVar201 ));
			float4 ifLocalVar185 = 0;
			if( _ToggleDirection == 1.0 )
				ifLocalVar185 = ( ( 1.0 - ( lerpResult150 * _PositionStrenght ) ) + tex2DNode1 );
			else
				ifLocalVar185 = tex2DNode1;
			float grayscale29 = dot(ifLocalVar185.rgb, float3(0.299,0.587,0.114));
			float mulTime96 = _Time.y * _Speed;
			float ifLocalVar95 = 0;
			if( _ToggleTime == 1.0 )
				ifLocalVar95 = (0.0 + (sin( mulTime96 ) - -1.0) * (1.0 - 0.0) / (1.0 - -1.0));
			else
				ifLocalVar95 = _Progress;
			float lerpResult13 = lerp( grayscale33 , grayscale29 , ifLocalVar95);
			float grayscale30 = dot(float3(1,1,1), float3(0.299,0.587,0.114));
			float lerpResult9 = lerp( grayscale29 , grayscale30 , ifLocalVar95);
			float lerpResult16 = lerp( lerpResult13 , lerpResult9 , ifLocalVar95);
			float temp_output_141_0 = ( 1.0 - lerpResult16 );
			float ifLocalVar142 = 0;
			if( _DissolveInvert == 1.0 )
				ifLocalVar142 = lerpResult16;
			else
				ifLocalVar142 = temp_output_141_0;
			float clampResult63 = clamp( (( 0.0 - _DissolveRange ) + (ifLocalVar142 - 0.0) * (_DissolveRange - ( 0.0 - _DissolveRange )) / (1.0 - 0.0)) , 0.0 , 1.0 );
			float temp_output_64_0 = ( 1.0 - clampResult63 );
			float2 appendResult65 = (float2(temp_output_64_0 , 0.0));
			float4 tex2DNode66 = tex2D( _DissolveRamp, appendResult65 );
			float4 temp_output_93_0 = ( tex2DNode66 * 5.0 * temp_output_64_0 * _DissolveColor );
			float mulTime139 = _Time.y * _ChromaSpeed;
			float3 hsvTorgb3_g1 = HSVToRGB( float3(mulTime139,1.0,1.0) );
			float4 ifLocalVar107 = 0;
			if( _ToggleChroma == 1.0 )
				ifLocalVar107 = ( ( float4( hsvTorgb3_g1 , 0.0 ) * 5.0 * tex2DNode66 * _DissolveColor ) * temp_output_64_0 * _Strength );
			else
				ifLocalVar107 = temp_output_93_0;
			float4 temp_output_105_0 = ( ifLocalVar107 + ( _EmissionColor * tex2D( _EmissionMap, uv_TexCoord121 ) ) );
			float4 clampResult199 = clamp( ( ( ( _Color * tex2DNode50 ) + temp_output_105_0 ) * (_BackfaceDimming + (i.ASEVFace - -1.0) * (1.0 - _BackfaceDimming) / (1.0 - -1.0)) ) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
			o.Albedo = clampResult199.rgb;
			float4 clampResult200 = clamp( temp_output_105_0 , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
			o.Emission = clampResult200.rgb;
			float4 tex2DNode131 = tex2D( _MetallicGlossMap, uv_TexCoord121 );
			o.Metallic = ( _Metaliic * tex2DNode131 ).r;
			o.Smoothness = ( _Glossiness * tex2DNode131.a );
			o.Alpha = 1;
			clip( ( tex2DNode50.a * ifLocalVar142 ) - _DissolveClip );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18100
-1853;498.2;1788;978;-3992.153;1138.437;1.081432;True;False
Node;AmplifyShaderEditor.CommentaryNode;183;-4057.829,193.2611;Inherit;False;2223.032;653.9238;World Module;15;151;155;176;153;146;150;149;148;147;177;184;196;197;201;210;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;195;-4337.73,757.3173;Inherit;False;Property;_ShiftSpeed;Shift Speed;28;0;Create;True;0;0;False;0;False;0.1176471;0.029;0;0.25;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;169;-3785.129,-49.78035;Inherit;False;Property;_DissolveMovement;Movement;23;0;Create;False;0;0;False;0;False;0,0;0,2;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleTimeNode;194;-3703.705,96.44641;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;196;-4018.73,761.3173;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;173;-3412.173,18.19246;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;172;-3415.167,-79.84537;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;197;-3829.754,758.3372;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;188;-3843.567,-160.5948;Inherit;False;Property;_ToggleMovement;Toggle Movement;22;0;Create;True;0;0;False;2;Toggle(_);Header(Movement);False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;191;-3310.995,107.1391;Inherit;False;Constant;_Float2;Float 2;32;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;192;-3264.644,-41.07999;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;147;-3737.478,632.9646;Inherit;False;Property;_DissolvePosition;Position;26;0;Create;False;0;0;False;0;False;0.884636;-1.2;-25;25;0;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;187;-3102.72,-100.7109;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PosVertexDataNode;146;-3978.688,223.5849;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;202;-3696.074,916.6774;Inherit;False;Property;_TogglePositionShift;Toggle Position Shift;27;0;Create;True;0;0;False;1;Toggle(_);False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;198;-3667.236,737.6592;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;-3;False;4;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;155;-3982.601,413.8546;Inherit;False;Property;_DissolveDirection;Direction;25;0;Create;False;0;0;False;0;False;0,0,0;0,0,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.BreakToComponentsNode;190;-3023.546,69.341;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.DotProductOpNode;210;-3433.914,375.1607;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;201;-3394.226,609.5613;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;135;-3152.193,-282.7286;Inherit;False;Property;_TODissolve;Tiling and Offset;19;0;Create;False;0;0;False;0;False;1,1,0,0;50,50,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;148;-3147.101,271.8945;Inherit;False;Constant;_Color1;Color 1;14;0;Create;True;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;71;-4463.271,-350.5272;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;174;-2744.767,64.20271;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;151;-3134.425,600.6029;Inherit;False;Constant;_Color0;Color 0;27;0;Create;True;0;0;False;0;False;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;175;-2748.835,-58.30471;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;149;-2992.016,465.0379;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;150;-2730.269,430.5999;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;75;-2600.167,30.27119;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;74;-2600.043,-103.7041;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;176;-2787.948,691.0925;Inherit;False;Property;_PositionStrenght;Strength;15;0;Create;False;0;0;False;0;False;0.884636;0.91;-2.5;2.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;177;-2470.927,466.3977;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;97;-4032.256,-436.642;Inherit;False;Property;_Speed;Speed;21;0;Create;True;0;0;False;0;False;1;0.25;0;0.25;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;76;-2371.092,-50.65538;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;96;-3713.256,-432.642;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;184;-2227.237,355.6007;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1;-2206.448,-79.39;Inherit;True;Property;_DissolveMap;Dissolve Map;12;1;[SingleLineTexture];Create;True;0;0;False;1;Header(Dissolve);False;-1;deb2cca25ab52e64c8d786f569c06f5b;c1a0d542354cd774fa8119540d407736;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;153;-2066.352,232.5172;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SinOpNode;98;-3524.28,-435.6221;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;186;-1962.375,-163.5295;Inherit;False;Property;_ToggleDirection;Toggle Direction;24;0;Create;True;0;0;False;2;Toggle(_);Header(Direction);False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;32;-2078.69,-755.4083;Inherit;True;Constant;_Vector1;Vector 1;6;0;Create;True;0;0;False;0;False;0,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;8;-2657.153,-265.4014;Inherit;False;Property;_Progress;Progress;17;0;Create;True;0;0;False;0;False;1;0.6;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;99;-3361.762,-456.3;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;31;-1582.141,99.35291;Inherit;False;Constant;_Vector0;Vector 0;6;0;Create;True;0;0;False;0;False;1,1,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ConditionalIfNode;185;-1802.226,-52.64129;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;1;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;94;-2369.233,-523.7027;Inherit;False;Property;_ToggleTime;Toggle Time;20;0;Create;True;0;0;False;2;Toggle(_);Header(Time);False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;95;-2243.656,-334.942;Inherit;True;False;5;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCGrayscale;29;-1624.214,-93.21899;Inherit;False;1;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCGrayscale;30;-1371.712,248.4041;Inherit;True;1;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCGrayscale;33;-1758.652,-583.2036;Inherit;True;1;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;13;-1372.948,-300.2457;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;9;-1358.799,16.05077;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;16;-1064.391,-172.2102;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;68;-880,-384;Inherit;False;Property;_DissolveRange;Range;16;0;Create;False;0;0;False;0;False;5.997281;5.997281;1;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;141;-785.7975,-43.42902;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;143;-823.8405,54.21091;Inherit;False;Property;_DissolveInvert;Invert;18;0;Create;False;0;0;False;1;Toggle(_);False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;142;-566.6017,-69.3055;Inherit;True;False;5;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;70;-464,-352;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;62;-278.489,-75.61041;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-4;False;4;FLOAT;4;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;63;33.72959,-75.79115;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;140;114.9654,-403.7072;Inherit;False;Property;_ChromaSpeed;Speed;30;0;Create;False;0;0;False;0;False;1;0.25;0;0.25;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;64;216.1653,-283.0036;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;118;-612.9521,477.2561;Inherit;False;Property;_TilingandOffset;Tiling and Offset;11;0;Create;False;0;0;False;0;False;1,1,0,0;1,1,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;65;404.1256,-204.6049;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;119;-344.9521,591.256;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;120;-341.9521,438.2561;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;139;433.9656,-399.7072;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;92;646.8828,71.34383;Inherit;False;Property;_DissolveColor;Dissolve Color;13;1;[HDR];Create;True;0;0;False;0;False;1,1,1,0;1.498039,1.498039,1.498039,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;111;870.7273,140.5441;Inherit;False;Constant;_Float0;Float 0;13;0;Create;True;0;0;False;0;False;5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;121;-156.9519,485.2561;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;108;748.6017,-399.6367;Inherit;True;Simple HUE;-1;;1;32abb5f0db087604486c2db83a2e817a;0;1;1;FLOAT;0;False;4;FLOAT3;6;FLOAT;7;FLOAT;5;FLOAT;8
Node;AmplifyShaderEditor.SamplerNode;66;601.0206,-154.8938;Inherit;True;Property;_DissolveRamp;Ramp;14;1;[SingleLineTexture];Create;False;0;0;False;0;False;-1;None;685115bd2ab09534bb958f25b1963fac;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;0,0;False;1;FLOAT2;1,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;137;203.7396,314.7886;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;144;950.5518,-489.2309;Inherit;False;Property;_Strength;Strength;31;0;Create;True;0;0;False;0;False;1;0;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;109;1053.199,-311.218;Inherit;True;4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;93;1230.436,-43.17869;Inherit;True;4;4;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;136;-529.0138,-385.0034;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;78;651.6085,260.5551;Inherit;False;Property;_EmissionColor;Emission Color;10;1;[HDR];Create;True;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;79;587.1135,604.951;Inherit;True;Property;_EmissionMap;Emission Map;9;1;[SingleLineTexture];Create;True;0;0;False;0;False;-1;None;db0e0545abb52ea45b2375c99c78af9b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;106;1274.702,-489.2177;Inherit;False;Property;_ToggleChroma;Toggle Chroma;29;0;Create;True;0;0;False;2;Toggle(_);Header(Chroma);False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;110;1347.654,-307.5193;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;17;-402.7529,-990.6326;Inherit;False;Property;_Color;Albedo Color;2;0;Create;False;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;50;-495.5215,-758.4246;Inherit;True;Property;_MainTex;Albedo Map;1;1;[SingleLineTexture];Create;False;0;0;False;1;Header(Main);False;-1;None;0ad9b3b9e20ca094793ed614245a009f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;77;966.1021,376.4089;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ConditionalIfNode;107;1662.531,-320.5544;Inherit;True;False;5;0;FLOAT;0;False;1;FLOAT;1;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FaceVariableNode;116;1659.267,-1102.839;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;49;612.7372,-813.3896;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;114;1489.831,-992.7894;Inherit;False;Property;_BackfaceDimming;Backface Dimming;32;0;Create;True;0;0;False;1;Header(Culling);False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;105;1989.655,-280.5799;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCRemapNode;115;1837.616,-1054.023;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;0.1;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;124;2442.269,601.4255;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;125;2225.852,662.9849;Inherit;False;Property;_NormalMapSlider;Normal Map Slider;8;0;Create;False;0;0;False;0;False;1;1;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;112;2134.237,-776.6766;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector3Node;129;2724.733,829.5789;Inherit;False;Constant;_Vector2;Vector 2;11;0;Create;True;0;0;False;0;False;0,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;117;2419.209,-779.0885;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;126;2689.385,526.5696;Inherit;False;Property;_UseNormalMap;Use Normal Map;6;0;Create;False;0;0;False;1;Toggle(_);False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;130;2646.499,346.5596;Inherit;False;Property;_Glossiness;Smoothness Slider;5;0;Create;False;0;0;False;0;False;0;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;127;2643.633,49.65329;Inherit;False;Property;_Metaliic;Metallic Slider;4;0;Create;False;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;128;2589.444,613.6757;Inherit;True;Property;_BumpMap;Normal Map;7;2;[Normal];[SingleLineTexture];Create;False;0;0;False;0;False;-1;None;76767365615d599459ecab5afc9a0bdb;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;0;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;131;2630.132,146.0205;Inherit;True;Property;_MetallicGlossMap;Metallic Map;3;1;[SingleLineTexture];Create;False;0;0;False;0;False;-1;None;b40f8bcce7451254c8e18eed6df03b76;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;200;4126.949,-189.8511;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;145;3108.989,-85.28512;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;134;3032.555,246.9666;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenColorNode;83;648.7188,-575.4171;Inherit;False;Global;_GrabScreen0;Grab Screen 0;12;0;Create;True;0;0;False;0;False;Object;-1;False;True;1;0;FLOAT4;0,0,0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;2;4936.175,-737.5828;Inherit;False;Property;_DissolveClip;Clip;33;0;Create;False;0;0;True;0;False;0.5;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;211;-17003.81,20795.2;Inherit;False;Property;_ThanksforusingmyShader1;Thanks for using my Shader!;0;0;Create;True;0;0;True;5;Header(Shader by tsuna vr);Header(Discord bDWEYUw);Header(Visit for commissions and free stuff);Space(25);Toggle(_);False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;132;2931.958,678.9404;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;133;3033.771,89.55843;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;113;4932.006,-847.3881;Inherit;False;Property;_Cull;Cull Mode ( 0 = None, 1 = Front, 2 = Back);34;0;Create;False;0;0;True;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;199;4115.771,-332.818;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;4721.873,-248.8393;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Tsuna/Dissolve WL;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Opaque;;AlphaTest;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;True;113;-1;0;True;2;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;196;0;195;0
WireConnection;173;0;194;0
WireConnection;173;1;169;2
WireConnection;172;0;194;0
WireConnection;172;1;169;1
WireConnection;197;0;196;0
WireConnection;192;0;172;0
WireConnection;192;1;173;0
WireConnection;187;0;188;0
WireConnection;187;2;191;0
WireConnection;187;3;192;0
WireConnection;187;4;191;0
WireConnection;198;0;197;0
WireConnection;190;0;187;0
WireConnection;210;0;146;0
WireConnection;210;1;155;0
WireConnection;201;0;202;0
WireConnection;201;2;147;0
WireConnection;201;3;198;0
WireConnection;201;4;147;0
WireConnection;174;0;135;4
WireConnection;174;1;190;1
WireConnection;175;0;135;3
WireConnection;175;1;190;0
WireConnection;149;0;210;0
WireConnection;149;1;201;0
WireConnection;150;0;148;0
WireConnection;150;1;151;0
WireConnection;150;2;149;0
WireConnection;75;0;71;2
WireConnection;75;1;135;2
WireConnection;75;2;174;0
WireConnection;74;0;71;1
WireConnection;74;1;135;1
WireConnection;74;2;175;0
WireConnection;177;0;150;0
WireConnection;177;1;176;0
WireConnection;76;0;74;0
WireConnection;76;1;75;0
WireConnection;96;0;97;0
WireConnection;184;0;177;0
WireConnection;1;1;76;0
WireConnection;153;0;184;0
WireConnection;153;1;1;0
WireConnection;98;0;96;0
WireConnection;99;0;98;0
WireConnection;185;0;186;0
WireConnection;185;2;1;0
WireConnection;185;3;153;0
WireConnection;185;4;1;0
WireConnection;95;0;94;0
WireConnection;95;2;8;0
WireConnection;95;3;99;0
WireConnection;95;4;8;0
WireConnection;29;0;185;0
WireConnection;30;0;31;0
WireConnection;33;0;32;0
WireConnection;13;0;33;0
WireConnection;13;1;29;0
WireConnection;13;2;95;0
WireConnection;9;0;29;0
WireConnection;9;1;30;0
WireConnection;9;2;95;0
WireConnection;16;0;13;0
WireConnection;16;1;9;0
WireConnection;16;2;95;0
WireConnection;141;0;16;0
WireConnection;142;0;143;0
WireConnection;142;2;141;0
WireConnection;142;3;16;0
WireConnection;142;4;141;0
WireConnection;70;1;68;0
WireConnection;62;0;142;0
WireConnection;62;3;70;0
WireConnection;62;4;68;0
WireConnection;63;0;62;0
WireConnection;64;0;63;0
WireConnection;65;0;64;0
WireConnection;119;0;118;3
WireConnection;119;1;118;4
WireConnection;120;0;118;1
WireConnection;120;1;118;2
WireConnection;139;0;140;0
WireConnection;121;0;120;0
WireConnection;121;1;119;0
WireConnection;108;1;139;0
WireConnection;66;1;65;0
WireConnection;137;0;121;0
WireConnection;109;0;108;6
WireConnection;109;1;111;0
WireConnection;109;2;66;0
WireConnection;109;3;92;0
WireConnection;93;0;66;0
WireConnection;93;1;111;0
WireConnection;93;2;64;0
WireConnection;93;3;92;0
WireConnection;136;0;137;0
WireConnection;79;1;121;0
WireConnection;110;0;109;0
WireConnection;110;1;64;0
WireConnection;110;2;144;0
WireConnection;50;1;136;0
WireConnection;77;0;78;0
WireConnection;77;1;79;0
WireConnection;107;0;106;0
WireConnection;107;2;93;0
WireConnection;107;3;110;0
WireConnection;107;4;93;0
WireConnection;49;0;17;0
WireConnection;49;1;50;0
WireConnection;105;0;107;0
WireConnection;105;1;77;0
WireConnection;115;0;116;0
WireConnection;115;3;114;0
WireConnection;124;0;121;0
WireConnection;112;0;49;0
WireConnection;112;1;105;0
WireConnection;117;0;112;0
WireConnection;117;1;115;0
WireConnection;128;1;124;0
WireConnection;128;5;125;0
WireConnection;131;1;121;0
WireConnection;200;0;105;0
WireConnection;145;0;50;4
WireConnection;145;1;142;0
WireConnection;134;0;130;0
WireConnection;134;1;131;4
WireConnection;132;0;126;0
WireConnection;132;2;129;0
WireConnection;132;3;128;0
WireConnection;132;4;129;0
WireConnection;133;0;127;0
WireConnection;133;1;131;0
WireConnection;199;0;117;0
WireConnection;0;0;199;0
WireConnection;0;1;132;0
WireConnection;0;2;200;0
WireConnection;0;3;133;0
WireConnection;0;4;134;0
WireConnection;0;10;145;0
ASEEND*/
//CHKSM=8B5D2AD3CB3D5A337BCCBBCC1455019DBD3A2379