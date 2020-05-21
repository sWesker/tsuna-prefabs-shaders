// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Tsuna/SatFry Volume FX"
{
	Properties
	{
		[Toggle]_ReduceColors("Reduce Colors", Float) = 1
		_Desaturate("Desaturate", Range( 0 , 1)) = 217.5057
		_ColorIndex("Color Index", Range( 1 , 256)) = 217.5057
		[Toggle]_Desat("Desat", Float) = 1
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Overlay"  "Queue" = "Overlay+0" "IsEmissive" = "true"  }
		Cull Off
		ZWrite On
		ZTest Always
		GrabPass{ }
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha noshadow noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd 
		struct Input
		{
			float4 screenPos;
		};

		uniform float _ReduceColors;
		uniform float _Desat;
		UNITY_DECLARE_SCREENSPACE_TEXTURE( _GrabTexture )
		uniform float _Desaturate;
		uniform float _ColorIndex;


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


		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ase_screenPos );
			float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
			float4 screenColor1 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,ase_grabScreenPosNorm.xy);
			float3 desaturateInitialColor16 = screenColor1.rgb;
			float desaturateDot16 = dot( desaturateInitialColor16, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar16 = lerp( desaturateInitialColor16, desaturateDot16.xxx, _Desaturate );
			float div7=256.0/float((int)_ColorIndex);
			float4 posterize7 = ( floor( lerp(screenColor1,float4( desaturateVar16 , 0.0 ),_Desat) * div7 ) / div7 );
			o.Emission = lerp(lerp(screenColor1,float4( desaturateVar16 , 0.0 ),_Desat),posterize7,_ReduceColors).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16800
1668;469;1906;1004;860.0763;419.7834;1;True;False
Node;AmplifyShaderEditor.GrabScreenPosition;5;-819.3811,-190.0278;Float;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;18;-574.0763,17.21661;Float;False;Property;_Desaturate;Desaturate;2;0;Create;True;0;0;False;0;217.5057;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenColorNode;1;-519.8128,-189.7617;Float;False;Global;_GrabScreen0;Grab Screen 0;0;0;Create;True;0;0;False;0;Object;-1;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DesaturateOpNode;16;-244.7168,-84.4851;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ToggleSwitchNode;17;-21.42999,-188.3705;Float;False;Property;_Desat;Desat;4;0;Create;True;0;0;False;0;1;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-77.59851,12.13788;Float;False;Property;_ColorIndex;Color Index;3;0;Create;True;0;0;False;0;217.5057;256;1;256;0;1;FLOAT;0
Node;AmplifyShaderEditor.PosterizeNode;7;228.4015,-98.86212;Float;False;256;2;1;COLOR;0,0,0,0;False;0;INT;256;False;1;COLOR;0
Node;AmplifyShaderEditor.ToggleSwitchNode;8;434.4015,-187.8621;Float;False;Property;_ReduceColors;Reduce Colors;1;0;Create;True;0;0;False;0;1;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;697.1711,-228.6;Float;False;True;2;Float;ASEMaterialInspector;0;0;Unlit;Tsuna/SatFry Volume FX;False;False;False;False;True;True;True;True;True;True;True;True;False;False;False;False;False;False;False;False;False;Off;1;False;-1;7;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;Overlay;;Overlay;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;1;0;5;0
WireConnection;16;0;1;0
WireConnection;16;1;18;0
WireConnection;17;0;1;0
WireConnection;17;1;16;0
WireConnection;7;1;17;0
WireConnection;7;0;9;0
WireConnection;8;0;17;0
WireConnection;8;1;7;0
WireConnection;0;2;8;0
ASEEND*/
//CHKSM=830207F70BB35626C71551726BD1FD834823C89B