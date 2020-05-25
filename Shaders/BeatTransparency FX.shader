// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Tsuna/BeatTransparency FX"
{
	Properties
	{
		[Header(Shader by tsuna vr)][Header(Discord bDWEYUw)][Header(Visit for commissions and free stuff)][Space(25)][Toggle(_)]_ThanksforusingmyShader1("Thanks for using my Shader!", Float) = 0
		[Header(Main)]_Color("Color", Color) = (0,0,0,0)
		_Glow("Glow", Range( 0 , 1)) = 0
		[Toggle(_)]_UseNormalmap("Use Normalmap", Float) = 0
		[Normal]_BumpMap("Normal Map", 2D) = "bump" {}
		_NormalMapSlider("Normal Map Slider", Range( 0 , 5)) = 1
		[Header(Fresnel)]_Clip("Clip", Range( 0 , 1)) = 0.5
		_Bias("Bias", Range( 0 , 1)) = 0.25
		_Scale("Scale", Range( 0 , 10)) = 1
		_Power("Power", Range( 0 , 1)) = 1
		[Header(Chroma)][Toggle(_)]_ToggleChroma("Toggle Chroma", Float) = 0
		_Speed("Speed", Range( 0 , 2)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Transparent+0" }
		Cull Back
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#include "UnityPBSLighting.cginc"
		#include "UnityStandardUtils.cginc"
		#include "UnityShaderVariables.cginc"
		#pragma target 2.0
		#pragma surface surf StandardCustomLighting keepalpha noshadow noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd 
		struct Input
		{
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
			float2 uv_texcoord;
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

		uniform float _Clip;
		uniform float _ThanksforusingmyShader1;
		uniform float _Glow;
		uniform float _UseNormalmap;
		uniform float _NormalMapSlider;
		uniform sampler2D _BumpMap;
		uniform float4 _BumpMap_ST;
		uniform float _Bias;
		uniform float _Scale;
		uniform float _Power;
		uniform float _ToggleChroma;
		uniform float4 _Color;
		uniform float _Speed;


		float3 HSVToRGB( float3 c )
		{
			float4 K = float4( 1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0 );
			float3 p = abs( frac( c.xxx + K.xyz ) * 6.0 - K.www );
			return c.z * lerp( K.xxx, saturate( p - K.xxx ), c.y );
		}


		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 _Vector0 = float3(0,0,1);
			float2 uv_BumpMap = i.uv_texcoord * _BumpMap_ST.xy + _BumpMap_ST.zw;
			float3 ifLocalVar33 = 0;
			if( _UseNormalmap == 1.0 )
				ifLocalVar33 = UnpackScaleNormal( tex2D( _BumpMap, uv_BumpMap ), _NormalMapSlider );
			else
				ifLocalVar33 = _Vector0;
			float fresnelNdotV7 = dot( (WorldNormalVector( i , ifLocalVar33 )), ase_worldViewDir );
			float fresnelNode7 = ( _Bias + _Scale * pow( 1.0 - fresnelNdotV7, _Power ) );
			float3 hsvTorgb3_g1 = HSVToRGB( float3(( _Time.y * _Speed ),1.0,1.0) );
			float4 ifLocalVar21 = 0;
			if( _ToggleChroma == 1.0 )
				ifLocalVar21 = float4( hsvTorgb3_g1 , 0.0 );
			else
				ifLocalVar21 = _Color;
			float4 clampResult35 = clamp( ( ifLocalVar21 * fresnelNode7 ) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
			c.rgb = clampResult35.rgb;
			c.a = ( _Glow + fresnelNode7 );
			clip( fresnelNode7 - _Clip );
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
			o.Normal = float3(0,0,1);
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18100
193.6;186.4;2608;1499;1522.178;368.8001;1;True;False
Node;AmplifyShaderEditor.RangedFloatNode;26;-2360.186,116.7824;Inherit;False;Property;_NormalMapSlider;Normal Map Slider;5;0;Create;True;0;0;False;0;False;1;1;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-1565.356,-288.3237;Inherit;False;Property;_Speed;Speed;11;0;Create;True;0;0;False;0;False;0;1;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;30;-2082.062,72.93688;Inherit;True;Property;_BumpMap;Normal Map;4;1;[Normal];Create;False;0;0;False;0;False;-1;None;76767365615d599459ecab5afc9a0bdb;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;0;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;17;-1491.929,-411.715;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;34;-2013.574,-208.1323;Inherit;False;Constant;_Vector0;Vector 0;11;0;Create;True;0;0;False;0;False;0,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;28;-2339.597,-70.7715;Inherit;False;Property;_UseNormalmap;Use Normalmap;3;0;Create;True;0;0;False;1;Toggle(_);False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;33;-1723.123,-47.12421;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-1245.161,-342.4937;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-1607.877,593.6447;Float;False;Property;_Scale;Scale;8;0;Create;True;0;0;False;0;False;1;1;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-1606.877,677.6447;Float;False;Property;_Power;Power;9;0;Create;True;0;0;False;0;False;1;0.7389513;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;4;-793.3777,-115.1894;Float;False;Property;_Color;Color;1;0;Create;True;0;0;False;1;Header(Main);False;0,0,0,0;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldNormalVector;32;-1515.312,305.1226;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.FunctionNode;15;-1061.389,-324.2782;Inherit;True;Simple HUE;-1;;1;32abb5f0db087604486c2db83a2e817a;0;1;1;FLOAT;0;False;4;FLOAT3;6;FLOAT;7;FLOAT;5;FLOAT;8
Node;AmplifyShaderEditor.RangedFloatNode;20;-758.611,-355.6529;Inherit;False;Property;_ToggleChroma;Toggle Chroma;10;0;Create;True;0;0;False;2;Header(Chroma);Toggle(_);False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;12;-1607.877,511.6447;Float;False;Property;_Bias;Bias;7;0;Create;True;0;0;False;0;False;0.25;0.1192833;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;21;-501.0826,-232.8488;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;1;False;2;COLOR;0,0,0,0;False;3;FLOAT3;0,0,0;False;4;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FresnelNode;7;-1219.526,376.9448;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1;-246.7867,227.6584;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;11;-1150,-48;Float;False;Property;_Glow;Glow;2;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-324.1797,682.1992;Inherit;False;Property;_ThanksforusingmyShader1;Thanks for using my Shader!;0;0;Create;True;0;0;True;5;Header(Shader by tsuna vr);Header(Discord bDWEYUw);Header(Visit for commissions and free stuff);Space(25);Toggle(_);False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;9;-747,79;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;22;-191.9993,405.0307;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;24;25.87978,-122.1634;Inherit;False;Property;_Clip;Clip;6;0;Create;True;0;0;True;1;Header(Fresnel);False;0.5;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;35;-58.02311,122.5244;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;3;148.8419,-1.193836;Float;False;True;-1;0;ASEMaterialInspector;0;0;CustomLighting;Tsuna/BeatTransparency FX;False;False;False;False;True;True;True;True;True;True;True;True;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;TransparentCutout;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;23;-1;0;True;24;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;30;5;26;0
WireConnection;33;0;28;0
WireConnection;33;2;34;0
WireConnection;33;3;30;0
WireConnection;33;4;34;0
WireConnection;18;0;17;0
WireConnection;18;1;19;0
WireConnection;32;0;33;0
WireConnection;15;1;18;0
WireConnection;21;0;20;0
WireConnection;21;2;4;0
WireConnection;21;3;15;6
WireConnection;21;4;4;0
WireConnection;7;0;32;0
WireConnection;7;1;12;0
WireConnection;7;2;13;0
WireConnection;7;3;14;0
WireConnection;1;0;21;0
WireConnection;1;1;7;0
WireConnection;9;0;11;0
WireConnection;9;1;7;0
WireConnection;22;0;7;0
WireConnection;35;0;1;0
WireConnection;3;9;9;0
WireConnection;3;10;22;0
WireConnection;3;13;35;0
ASEEND*/
//CHKSM=F8734EB34C0354BBB5574482138B46B0CD3E6032