// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Tsuna/Teddy Vision Contain FX"
{
	Properties
	{
		[Toggle]_ReduceColors("Reduce Colors", Float) = 0
		_ColorIndex("Color Index", Range( 1 , 256)) = 1
		_Speed("Speed", Range( 0 , 10)) = 0
		[Toggle]_TimeShift("Time Shift", Float) = 0
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Overlay"  "Queue" = "Overlay+0" "IsEmissive" = "true"  }
		Cull Off
		ZWrite On
		ZTest Greater
		GrabPass{ }
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha noshadow noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd 
		struct Input
		{
			float4 screenPos;
		};

		uniform float _ReduceColors;
		uniform float _TimeShift;
		UNITY_DECLARE_SCREENSPACE_TEXTURE( _GrabTexture )
		uniform float _Speed;
		uniform float _ColorIndex;


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
			float temp_output_2_0 = length( screenColor1 );
			float mulTime10 = _Time.y * _Speed;
			float3 hsvTorgb3_g2 = HSVToRGB( float3(lerp(temp_output_2_0,( sin( mulTime10 ) * temp_output_2_0 ),_TimeShift),1.0,1.0) );
			float3 temp_output_6_6 = hsvTorgb3_g2;
			float div7=256.0/float((int)_ColorIndex);
			float4 posterize7 = ( floor( float4( temp_output_6_6 , 0.0 ) * div7 ) / div7 );
			o.Emission = lerp(float4( temp_output_6_6 , 0.0 ),posterize7,_ReduceColors).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16800
527;888;1906;1004;1514.301;573.6893;1.333829;True;False
Node;AmplifyShaderEditor.RangedFloatNode;13;-1096.599,-337.5621;Float;False;Property;_Speed;Speed;3;0;Create;True;0;0;False;0;0;0;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.GrabScreenPosition;5;-1066.187,-124.2049;Float;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;10;-788.5985,-332.5621;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenColorNode;1;-764.5858,-122.905;Float;False;Global;_GrabScreen0;Grab Screen 0;0;0;Create;True;0;0;False;0;Object;-1;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SinOpNode;14;-553.5985,-281.5621;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;2;-552.2863,-118.005;Float;False;1;0;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-384.4984,-209.3621;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;15;-205.8313,-122.351;Float;False;Property;_TimeShift;Time Shift;4;0;Create;True;0;0;False;0;0;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-87.59851,34.13788;Float;False;Property;_ColorIndex;Color Index;2;0;Create;True;0;0;False;0;1;1;1;256;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;6;12.2135,-118.4049;Float;False;Simple HUE;-1;;2;32abb5f0db087604486c2db83a2e817a;0;1;1;FLOAT;0;False;4;FLOAT3;6;FLOAT;7;FLOAT;5;FLOAT;8
Node;AmplifyShaderEditor.PosterizeNode;7;246.4015,-49.86212;Float;False;256;2;1;COLOR;0,0,0,0;False;0;INT;256;False;1;COLOR;0
Node;AmplifyShaderEditor.ToggleSwitchNode;8;465.4015,-122.8621;Float;False;Property;_ReduceColors;Reduce Colors;1;0;Create;True;0;0;False;0;0;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;728.1711,-163.6;Float;False;True;2;Float;ASEMaterialInspector;0;0;Unlit;Tsuna/Teddy Vision Contain FX;False;False;False;False;True;True;True;True;True;True;True;True;False;False;False;False;False;False;False;False;False;Off;1;False;-1;2;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;Overlay;;Overlay;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;10;0;13;0
WireConnection;1;0;5;0
WireConnection;14;0;10;0
WireConnection;2;0;1;0
WireConnection;11;0;14;0
WireConnection;11;1;2;0
WireConnection;15;0;2;0
WireConnection;15;1;11;0
WireConnection;6;1;15;0
WireConnection;7;1;6;6
WireConnection;7;0;9;0
WireConnection;8;0;6;6
WireConnection;8;1;7;0
WireConnection;0;2;8;0
ASEEND*/
//CHKSM=D66E64F4C8A5FD827F92581D4DC35AC6F2624FF4