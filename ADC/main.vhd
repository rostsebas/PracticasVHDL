library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;

entity main is
Generic(
		Velocidad: Natural  := 600
	);
	Port(		
			
		Clk			:	In		Std_Logic;		--Señal de Reloj de entrada.
		SClk			:	Out	Std_Logic;		--Señal de Reloj de salida, para el ADC.
		DataOut		:	Out	Std_Logic;		--Dato de Salida, seleccion del canal del ADC.
		DataIn		:	In		Std_Logic;		--Dato de Entrada, dato que envia el ADC.
		ChipSelect	:	Out	Std_Logic;		--Señal de seleccion para el ADC.
		--Dato			:	Out	Std_Logic_Vector(11 DownTo 0);		--Dato resivido del ADC.
		EnableADC	:	In		Std_Logic;	--Habilitador del modulo.
		-- mostrar display
		Enable:	out	std_logic_vector(2 downto 0);
		Display: out 	std_logic_vector(7 downto 0);
		-- leds indicadores
		LedAzul			:	Out	Std_Logic;
		LedRojo			:	Out	Std_Logic;		
		-- reiniciar distancia
		reiniciar	:	In		Std_Logic
	);
end main;

architecture Behavioral of main is
--Señales utilizadas para generar la señal de reloj para el ADC.
	Signal ContadorReloj: 		Integer Range 0 to 13000000;
	Signal EstadoSclk:			Std_Logic:='0';
	Signal NotEstadoSclk:		Std_Logic;
	--Señal utilizada para controlar el ChipSelect del ADC.
	Signal EstadoChipSelect: 	Std_Logic;
	--Señal de control.
	Signal Conteo: 				Integer Range 0 to 30;
	--Señales utlizadas para la lectura del ADC.
	Signal EnableLectura:		Std_Logic;
	Signal NoBit:					Integer Range 0 to 20;
	Signal Valor:					Std_Logic_Vector(11 DownTo 0):="000000000000";
	Signal EstadoDato:			Std_Logic_Vector(11 DownTo 0):="000000000000";
	Signal EstadoDatoEntero: 		Integer Range 0 to 1000000;

	Type ComunicacionSPI is (Espera,Inicio,LeerDatos);
	Signal Estado: ComunicacionSPI;
	
	-- tiempo de muestreo 
	-- 12Mhz / 1 s = N / T(s)
   -- 12Mhz / 1 s = N / 0.005     N=60000        
	constant tiempoTotal : integer:= 60000;
	signal tiempoTranscurrido: integer range 0 to tiempoTotal;	
	signal det: integer:=0;
	
	--Displays
	signal cont_multiplexacion:	integer range 0 to 12000000;
	signal estado_enable:	std_logic_vector(2 downto 0);
	signal estado_display:	integer range 0 to 9;

	signal unidades:	integer range 0 to 9;
   signal unidades2:	integer range 0 to 9;
	
begin

Process(Clk, NotEstadoSclk)
Begin

	If(Clk'Event and Clk = '1') then
		If EnableADC = '1' then
			--En esta parte se genera la señal de reloj para el modulo ADC, SClk.
			If(ContadorReloj = Velocidad-1) then
				ContadorReloj <= 0;
				If(EstadoSClk = '0') then
					EstadoSclk <= '1';
				Else
					EstadoSclk <= '0';
				End IF;
			Else
				ContadorReloj <= ContadorReloj + 1;
			End If;
		Else
			ContadorReloj <= 0;
			EstadoSCLK <= '1';
		End If;
	End if;
	If (Rising_Edge(NotEstadoSClk)) then
		If(EnableLectura = '1') then				
			--En esta parte se leen los datos recibidos, bit por bit, y se guardan en el arreglo "Valor"
			If (NoBit = 0) then
				NoBit <= NoBit + 1;
			ElsIf (NoBit = 1) then
				Valor(11) <= DataIn;
				NoBit <= NoBit + 1;
			ElsIf(NoBit = 2) then
				Valor(10) <= DataIn;
				NoBit <= NoBit + 1;
			ElsIf(NoBit = 3) then
				Valor(9) <= DataIn;
				NoBit <= NoBit + 1;
			ElsIf(NoBit = 4) then
				Valor(8) <= DataIn;
				NoBit <= NoBit + 1;
			ElsIf(NoBit = 5) then
				Valor(7) <= DataIn;
				NoBit <= NoBit + 1;
			ElsIf(NoBit = 6) then
				Valor(6) <= DataIn;
				NoBit <= NoBit + 1;
			ElsIf(NoBit = 7) then
				Valor(5) <= DataIn;
				NoBit <= NoBit + 1;
			ElsIf(NoBit = 8) then
				Valor(4) <= DataIn;
				NoBit <= NoBit + 1;
			ElsIf(NoBit = 9) then
				Valor(3) <= DataIn;
				NoBit <= NoBit + 1;
			ElsIf(NoBit = 10) then
				Valor(2) <= DataIn;
				NoBit <= NoBit + 1;
			ElsIf(NoBit = 11) then
				Valor(1) <= DataIn;
				NoBit <= NoBit + 1;
			ElsIf(NoBit = 12) then
				Valor(0) <= DataIn;
				NoBit <= 0;
			Else
				NoBit <= 0;
			End If;
		Else
			--Al finalizar la lectura de los datos recibidos se define el valor de los datos de salida del modulo.
			NoBit <= 0;
			EstadoDato(11 DownTo 0) <= Valor(11 DownTo 0);
		End If;
	End if;
End Process;

Process(EstadoSclk)
Begin
	If(Rising_Edge(EstadoSClk)) then
	Case Estado is
		--En este estado se esperan 2 cilcos de SClk, para iniciar la secuencia de lectura del ADC.
		When Espera =>
			If(Conteo = 2) then
				Conteo <= 0;
				Estado <= Inicio;
			Else
				Conteo <= Conteo + 1;
				EstadoChipSelect <= '1';
				DataOut <= '0';
			End If;
		--En este estado se envian los datos necesarios al ADC para poder leer el canal 0 en modo simple.
		When Inicio =>
			If(Conteo = 0) then
				EstadoChipSelect <= '0';
				DataOut <= '1';
				Conteo <= Conteo + 1;
			ElsIf(Conteo = 2) then
				DataOut <= '0';
				Conteo <= Conteo + 1;
			ElsIf(Conteo = 4) then
				Conteo <= 0;
				Estado <= LeerDatos;
			Else
				Conteo <= Conteo + 1;
			End If;
		--En este estado se habilita la lectura de los datos recibidos del ADC.
		When LeerDatos =>
			If(Conteo = 1) then
				EnableLectura <= '1';
				Conteo <= Conteo + 1;
			ElsIf(Conteo = 14) then
				Conteo <= 0;
				EnableLectura <= '0';
				Estado <= Espera;
			Else
				Conteo <= Conteo + 1;
			End If;
	End Case;
	End If;
End Process;

--En esta parte se definen los estados de las salidas del modulo.
NotEstadoSclk <= Not(EstadoSclk);
Sclk <= Not(EstadoSclk);
ChipSelect <= EstadoChipSelect;
--Dato(11 DownTo 0) <= EstadoDato(11 DownTo 0);
EstadoDatoEntero <= to_integer(unsigned(EstadoDato));

Enable <= estado_enable;

process(clk, reiniciar)
		begin
		
		
      if(EstadoDatoEntero <= 3200) then
		  unidades <= 0;
		else
		
			if (det = 0) then
				if (EstadoDatoEntero > 3200 and EstadoDatoEntero <= 3222) then
					unidades <= 9;
					if (unidades >= unidades2) then unidades2 <= unidades; end if;
				elsif (EstadoDatoEntero > 3222 and EstadoDatoEntero <= 3244) then
					unidades <= 8;
					if (unidades >= unidades2) then unidades2 <= unidades; end if;
				elsif (EstadoDatoEntero > 3244 and EstadoDatoEntero <= 3266) then
					unidades <= 7;
					if (unidades >= unidades2) then unidades2 <= unidades; end if;
				elsif (EstadoDatoEntero > 3266 and EstadoDatoEntero <= 3288) then
					unidades <= 6;
					if (unidades >= unidades2) then unidades2 <= unidades; end if;
				elsif (EstadoDatoEntero > 3288 and EstadoDatoEntero <= 3310) then
					unidades <= 5;
					if (unidades >= unidades2) then unidades2 <= unidades; end if;
				elsif (EstadoDatoEntero > 3310 and EstadoDatoEntero <= 3332) then
					unidades <= 4;
					if (unidades >= unidades2) then unidades2 <= unidades; end if;
				elsif (EstadoDatoEntero > 3332 and EstadoDatoEntero <= 3354) then
					unidades <= 3;
					if (unidades >= unidades2) then unidades2 <= unidades; end if;
				elsif (EstadoDatoEntero > 3354 and EstadoDatoEntero <= 3376) then
					unidades <= 2;
					if (unidades >= unidades2) then unidades2 <= unidades; end if;
				elsif (EstadoDatoEntero > 3376 and EstadoDatoEntero <= 3398) then
					unidades <= 1;
					if (unidades >= unidades2) then unidades2 <= unidades; end if;
				end if;
				
				if(rising_edge(Clk)) then
					if(tiempoTranscurrido = tiempoTotal) then
						tiempoTranscurrido <= 0;
						det <= 1;
					else
						tiempoTranscurrido <= tiempoTranscurrido + 1;
					end if;
				end if;
			
			end if;
			
		end if;
		
		estado_enable <= "110";
		estado_display <= unidades2;
		case estado_display is
				 when 0 => 
					Display <= "11000000";
				 when 1 => 
					Display <= "11111001";
				 when 2 => 
					Display <= "10100100";
				 when 3 => 
					Display <= "10110000";
				 when 4 => 
					Display <= "10011001";
				 when 5 => 
					Display <= "10010010";
				 when 6 => 
					Display <= "10000010";
				 when 7 => 
					Display <= "11111000";
				 when 8 => 
					Display <= "10000000";
				 when 9 => 
					Display <= "10011000";
				 when others => 
					Display <= "11111111";
			end case;
			
			if(reiniciar = '0') then
				unidades2 <= 0;
				det <= 0;
			end if;
			
	end process;
	
end Behavioral;

