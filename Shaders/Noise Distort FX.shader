// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Tsuna/Noise Distort FX"
{
	Properties
	{
		[Header(Shader by tsuna vr)][Header(Discord bDWEYUw)][Header(Visit for commissions and free stuff)][Space(25)][Toggle(_)]_ThanksforusingmyShader2("Thanks for using my Shader!", Float) = 0
		[SingleLineTexture][Header(Main)]_MainTex("Albedo Map", 2D) = "white" {}
		_Color("Albedo Color", Color) = (1,1,1,0)
		[SingleLineTexture]_MetallicGlossMap("Metallic Map", 2D) = "white" {}
		_Metaliic("Metallic Slider", Range( 0 , 1)) = 0
		_Glossiness("Smoothness Slider", Range( 0 , 1)) = 0
		[Toggle(_)]_UseNormalMap("Use Normal Map", Float) = 0
		[Toggle(_)]_UseNormalMap1("Use UV-Based Noise", Float) = 0
		[Normal][SingleLineTexture]_BumpMap("Normal Map", 2D) = "bump" {}
		_NormalMapSlider("Normal Map Slider", Range( 0 , 5)) = 1
		[SingleLineTexture]_EmissionMap("Emission Map", 2D) = "black" {}
		[HDR]_EmissionColor("Emission Color", Color) = (0,0,0,0)
		_TilingandOffset("Tiling and Offset", Vector) = (1,1,0,0)
		[Header(Vertex Distort)]_DistortStrength("Distort Strength", Range( 0 , 1)) = 1
		_DistortScale("Distort Scale", Range( 0 , 10)) = 6.411765
		_DistortSpeed("Distort Speed", Range( 0 , 1)) = 1
		_DistortDirection("Distort Direction", Vector) = (0,0,0,0)
		[Header(Exclusion)]_MinRange("Min Range", Range( 0 , 6)) = 6
		_MaxRange("Max Range", Range( 0 , 6)) = 2.537596
		_DissolveDirection("Exclusion Area", Vector) = (0,0,0,0)
		[HideInInspector]_Clip("Clip", Float) = 0.5
		[Header(Culling)]_CullMode("Cull Mode ( 0 = None, 1 = Front, 2 = Back)", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull [_CullMode]
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "UnityStandardUtils.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float _ThanksforusingmyShader2;
		uniform float _Clip;
		uniform float _CullMode;
		uniform float _UseNormalMap1;
		uniform float4 _TilingandOffset;
		uniform float _DistortSpeed;
		uniform float _DistortScale;
		uniform float _DistortStrength;
		uniform float3 _DistortDirection;
		uniform float3 _DissolveDirection;
		uniform float _MinRange;
		uniform float _MaxRange;
		uniform float _UseNormalMap;
		uniform float _NormalMapSlider;
		uniform sampler2D _BumpMap;
		uniform float4 _Color;
		uniform sampler2D _MainTex;
		uniform sampler2D _EmissionMap;
		uniform float4 _EmissionColor;
		uniform float _Metaliic;
		uniform sampler2D _MetallicGlossMap;
		uniform float _Glossiness;


		float ComposeTrackingData( float4 PlayerTransform , float3 VertWorldPos , float MinRange , float MaxRange )
		{
			return (0.0 + ( clamp( distance( PlayerTransform.xyz , VertWorldPos ) , MinRange , MaxRange ) - MaxRange) * (1.0 - 0.0) / (MinRange - MaxRange));
		}


		float3 mod3D289( float3 x ) { return x - floor( x / 289.0 ) * 289.0; }

		float4 mod3D289( float4 x ) { return x - floor( x / 289.0 ) * 289.0; }

		float4 permute( float4 x ) { return mod3D289( ( x * 34.0 + 1.0 ) * x ); }

		float4 taylorInvSqrt( float4 r ) { return 1.79284291400159 - r * 0.85373472095314; }

		float snoise( float3 v )
		{
			const float2 C = float2( 1.0 / 6.0, 1.0 / 3.0 );
			float3 i = floor( v + dot( v, C.yyy ) );
			float3 x0 = v - i + dot( i, C.xxx );
			float3 g = step( x0.yzx, x0.xyz );
			float3 l = 1.0 - g;
			float3 i1 = min( g.xyz, l.zxy );
			float3 i2 = max( g.xyz, l.zxy );
			float3 x1 = x0 - i1 + C.xxx;
			float3 x2 = x0 - i2 + C.yyy;
			float3 x3 = x0 - 0.5;
			i = mod3D289( i);
			float4 p = permute( permute( permute( i.z + float4( 0.0, i1.z, i2.z, 1.0 ) ) + i.y + float4( 0.0, i1.y, i2.y, 1.0 ) ) + i.x + float4( 0.0, i1.x, i2.x, 1.0 ) );
			float4 j = p - 49.0 * floor( p / 49.0 );  // mod(p,7*7)
			float4 x_ = floor( j / 7.0 );
			float4 y_ = floor( j - 7.0 * x_ );  // mod(j,N)
			float4 x = ( x_ * 2.0 + 0.5 ) / 7.0 - 1.0;
			float4 y = ( y_ * 2.0 + 0.5 ) / 7.0 - 1.0;
			float4 h = 1.0 - abs( x ) - abs( y );
			float4 b0 = float4( x.xy, y.xy );
			float4 b1 = float4( x.zw, y.zw );
			float4 s0 = floor( b0 ) * 2.0 + 1.0;
			float4 s1 = floor( b1 ) * 2.0 + 1.0;
			float4 sh = -step( h, 0.0 );
			float4 a0 = b0.xzyw + s0.xzyw * sh.xxyy;
			float4 a1 = b1.xzyw + s1.xzyw * sh.zzww;
			float3 g0 = float3( a0.xy, h.x );
			float3 g1 = float3( a0.zw, h.y );
			float3 g2 = float3( a1.xy, h.z );
			float3 g3 = float3( a1.zw, h.w );
			float4 norm = taylorInvSqrt( float4( dot( g0, g0 ), dot( g1, g1 ), dot( g2, g2 ), dot( g3, g3 ) ) );
			g0 *= norm.x;
			g1 *= norm.y;
			g2 *= norm.z;
			g3 *= norm.w;
			float4 m = max( 0.6 - float4( dot( x0, x0 ), dot( x1, x1 ), dot( x2, x2 ), dot( x3, x3 ) ), 0.0 );
			m = m* m;
			m = m* m;
			float4 px = float4( dot( x0, g0 ), dot( x1, g1 ), dot( x2, g2 ), dot( x3, g3 ) );
			return 42.0 * dot( m, px);
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertex3Pos = v.vertex.xyz;
			float2 appendResult47 = (float2(_TilingandOffset.x , _TilingandOffset.y));
			float2 appendResult46 = (float2(_TilingandOffset.z , _TilingandOffset.w));
			float2 uv_TexCoord48 = v.texcoord.xy * appendResult47 + appendResult46;
			float3 ifLocalVar66 = 0;
			if( _UseNormalMap1 == 1.0 )
				ifLocalVar66 = float3( uv_TexCoord48 ,  0.0 );
			else
				ifLocalVar66 = ase_vertex3Pos;
			float3 appendResult1 = (float3(_Time.y , _Time.y , _Time.y));
			float simplePerlin3D31 = snoise( ( ( ifLocalVar66 - appendResult1 ) * _DistortSpeed )*_DistortScale );
			simplePerlin3D31 = simplePerlin3D31*0.5 + 0.5;
			float4 PlayerTransform14 = float4( _DissolveDirection , 0.0 );
			float3 VertWorldPos14 = ase_vertex3Pos;
			float MinRange14 = _MinRange;
			float MaxRange14 = _MaxRange;
			float localComposeTrackingData14 = ComposeTrackingData( PlayerTransform14 , VertWorldPos14 , MinRange14 , MaxRange14 );
			v.vertex.xyz += ( ( ( simplePerlin3D31 * (-1.0 + (simplePerlin3D31 - 0.0) * (1.0 - -1.0) / (1.0 - 0.0)) * _DistortStrength ) * _DistortDirection ) * localComposeTrackingData14 );
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 _Vector1 = float3(0,0,1);
			float2 appendResult47 = (float2(_TilingandOffset.x , _TilingandOffset.y));
			float2 appendResult46 = (float2(_TilingandOffset.z , _TilingandOffset.w));
			float2 uv_TexCoord48 = i.uv_texcoord * appendResult47 + appendResult46;
			float3 ifLocalVar57 = 0;
			if( _UseNormalMap == 1.0 )
				ifLocalVar57 = UnpackScaleNormal( tex2D( _BumpMap, uv_TexCoord48 ), _NormalMapSlider );
			else
				ifLocalVar57 = _Vector1;
			o.Normal = ifLocalVar57;
			o.Albedo = ( _Color * tex2D( _MainTex, uv_TexCoord48 ) ).rgb;
			o.Emission = ( tex2D( _EmissionMap, uv_TexCoord48 ) * _EmissionColor ).rgb;
			float4 tex2DNode59 = tex2D( _MetallicGlossMap, uv_TexCoord48 );
			o.Metallic = ( _Metaliic * tex2DNode59 ).r;
			o.Smoothness = ( _Glossiness * tex2DNode59.a );
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18100
637.6;629.6;1317;784;2562.701;522.0209;1.775752;True;False
Node;AmplifyShaderEditor.Vector4Node;45;-2012.074,672.0022;Inherit;False;Property;_TilingandOffset;Tiling and Offset;12;0;Create;False;0;0;False;0;False;1,1,0,0;1,1,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;46;-1756.074,784.0021;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;47;-1740.074,640.0022;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;48;-1564.074,688.0022;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PosVertexDataNode;16;-1883.21,-134.0026;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;11;-1369.818,267.1454;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;67;-1920.67,-252.0717;Inherit;False;Property;_UseNormalMap1;Use UV-Based Noise;7;0;Create;False;0;0;False;1;Toggle(_);False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;1;-1140.489,268.7266;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ConditionalIfNode;66;-1503.449,12.98815;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT3;0,0,0;False;3;FLOAT2;0,0;False;4;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;5;-887.8576,243.8478;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-1109.258,457.0479;Inherit;False;Property;_DistortSpeed;Distort Speed;15;0;Create;False;0;0;False;0;False;1;0.16;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-864.4599,531.2193;Inherit;False;Property;_DistortScale;Distort Scale;14;0;Create;False;0;0;False;0;False;6.411765;2.49;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-704.9576,236.9477;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;31;-122.7581,243.4093;Inherit;True;Simplex3D;True;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-506.7703,624.7592;Inherit;False;Property;_DistortStrength;Distort Strength;13;0;Create;False;0;0;False;1;Header(Vertex Distort);False;1;0.38;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;35;306.8599,309.4189;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-1;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;17;-1086.71,-269.3421;Inherit;False;Property;_DissolveDirection;Exclusion Area;19;0;Create;False;0;0;False;0;False;0,0,0;0,1,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;33;779.9558,160.2856;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;54;217.1368,1169.305;Inherit;False;Property;_NormalMapSlider;Normal Map Slider;9;0;Create;False;0;0;False;0;False;1;1;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-1011.93,9.331598;Inherit;False;Property;_MinRange;Min Range;17;0;Create;True;0;0;False;1;Header(Exclusion);False;6;1.2;0;6;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-1011.93,108.3316;Inherit;False;Property;_MaxRange;Max Range;18;0;Create;True;0;0;False;0;False;2.537596;1.91;0;6;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;2;689.2302,367.1418;Inherit;False;Property;_DistortDirection;Distort Direction;16;0;Create;False;0;0;False;0;False;0,0,0;1,0,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;975.2124,256.3956;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector3Node;56;665.1364,1345.305;Inherit;False;Constant;_Vector1;Vector 0;11;0;Create;True;0;0;False;0;False;0,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CustomExpressionNode;14;-567.1237,-162.6945;Inherit;False;return (0.0 + ( clamp( distance( PlayerTransform.xyz , VertWorldPos ) , MinRange , MaxRange ) - MaxRange) * (1.0 - 0.0) / (MinRange - MaxRange))@;1;False;4;True;PlayerTransform;FLOAT4;0,0,0,0;In;;Inherit;False;True;VertWorldPos;FLOAT3;0,0,0;In;;Inherit;False;True;MinRange;FLOAT;0;In;;Inherit;False;True;MaxRange;FLOAT;1;In;;Inherit;False;ComposeTrackingData;False;True;0;4;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;3;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;59;378.4427,725.1934;Inherit;True;Property;_MetallicGlossMap;Metallic Map;3;1;[SingleLineTexture];Create;False;0;0;False;0;False;-1;None;6d8e8045b0d49fd43bcffeac14489d96;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;51;-508.045,971.3376;Inherit;True;Property;_MainTex;Albedo Map;1;1;[SingleLineTexture];Create;False;0;0;False;1;Header(Main);False;-1;None;bf4ffbffe3841e54faa4c30adacb38fc;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;49;1083.633,602.5369;Inherit;True;Property;_EmissionMap;Emission Map;10;1;[SingleLineTexture];Create;False;0;0;False;0;False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;53;-428.0449,795.3375;Inherit;False;Property;_Color;Albedo Color;2;0;Create;False;0;0;False;0;False;1,1,1,0;1,1,1,0.5019608;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;61;394.4417,629.1936;Inherit;False;Property;_Metaliic;Metallic Slider;4;0;Create;False;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;60;394.4417,917.1938;Inherit;False;Property;_Glossiness;Smoothness Slider;5;0;Create;False;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;58;617.1365,1039.705;Inherit;False;Property;_UseNormalMap;Use Normal Map;6;0;Create;False;0;0;False;1;Toggle(_);False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;50;1131.634,810.5367;Inherit;False;Property;_EmissionColor;Emission Color;11;1;[HDR];Create;False;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;55;521.1364,1121.305;Inherit;True;Property;_BumpMap;Normal Map;8;2;[Normal];[SingleLineTexture];Create;False;0;0;False;0;False;-1;None;553638d5ba85bc447836ad5a8a59aace;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;0;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;52;-92.04485,923.3375;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;65;90.63721,1629.191;Inherit;False;Property;_ThanksforusingmyShader2;Thanks for using my Shader!;0;0;Create;True;0;0;True;5;Header(Shader by tsuna vr);Header(Discord bDWEYUw);Header(Visit for commissions and free stuff);Space(25);Toggle(_);False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;57;873.1364,1185.305;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;41;1170.391,170.241;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;62;778.4414,661.1935;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;63;778.4414,821.1937;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;911.0906,-159.3788;Inherit;False;Property;_Clip;Clip;20;1;[HideInInspector];Create;False;0;0;True;0;False;0.5;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;64;1476.666,645.2283;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;12;1281.561,395.4579;Inherit;False;Property;_CullMode;Cull Mode ( 0 = None, 1 = Front, 2 = Back);21;0;Create;False;0;0;True;1;Header(Culling);False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1337.503,-62.4054;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Tsuna/Noise Distort FX;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;True;12;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;46;0;45;3
WireConnection;46;1;45;4
WireConnection;47;0;45;1
WireConnection;47;1;45;2
WireConnection;48;0;47;0
WireConnection;48;1;46;0
WireConnection;1;0;11;0
WireConnection;1;1;11;0
WireConnection;1;2;11;0
WireConnection;66;0;67;0
WireConnection;66;2;16;0
WireConnection;66;3;48;0
WireConnection;66;4;16;0
WireConnection;5;0;66;0
WireConnection;5;1;1;0
WireConnection;7;0;5;0
WireConnection;7;1;4;0
WireConnection;31;0;7;0
WireConnection;31;1;6;0
WireConnection;35;0;31;0
WireConnection;33;0;31;0
WireConnection;33;1;35;0
WireConnection;33;2;8;0
WireConnection;3;0;33;0
WireConnection;3;1;2;0
WireConnection;14;0;17;0
WireConnection;14;1;16;0
WireConnection;14;2;18;0
WireConnection;14;3;19;0
WireConnection;59;1;48;0
WireConnection;51;1;48;0
WireConnection;49;1;48;0
WireConnection;55;1;48;0
WireConnection;55;5;54;0
WireConnection;52;0;53;0
WireConnection;52;1;51;0
WireConnection;57;0;58;0
WireConnection;57;2;56;0
WireConnection;57;3;55;0
WireConnection;57;4;56;0
WireConnection;41;0;3;0
WireConnection;41;1;14;0
WireConnection;62;0;61;0
WireConnection;62;1;59;0
WireConnection;63;0;60;0
WireConnection;63;1;59;4
WireConnection;64;0;49;0
WireConnection;64;1;50;0
WireConnection;0;0;52;0
WireConnection;0;1;57;0
WireConnection;0;2;64;0
WireConnection;0;3;62;0
WireConnection;0;4;63;0
WireConnection;0;11;41;0
ASEEND*/
//CHKSM=5638C87B7433D4618BE1F68F5F5E6572B55B8D10