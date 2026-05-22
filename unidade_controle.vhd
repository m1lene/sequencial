LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY unidade_controle IS
    PORT(
        clk, rst              : IN  std_logic;
        start, finish         : IN  std_logic;
        timer_30, timer_15    : IN  std_logic;
        led_red, led_green    : OUT std_logic);
END ENTITY;

ARCHITECTURE comportamento OF unidade_controle IS

    -- Criação dos estados da máquina de estados
    TYPE estados IS (idle, vermelho, verde);

    -- Sinais para armazenar o estado atual e o próximo estado
    SIGNAL estadoPresente, estadoProximo : estados;
BEGIN

    -------------------------------------------------------------------
    -- Lógica Sequencial
    -- Atualiza o estado atual no pulso de clock
    -------------------------------------------------------------------
	sequencial : PROCESS(clk, rst)
	BEGIN

	-- Reset: volta para o estado inicial
		IF rst = '1' THEN
			estadoPresente <= idle;

        -- Na borda de subida do clock
		ELSIF clk'EVENT AND clk = '1' THEN
			estadoPresente <= estadoProximo;
		END IF;
	END PROCESS;

  -------------------------------------------------------------------
    -- Lógica Combinacional
    -- Define as saídas e o próximo estado
    -------------------------------------------------------------------
	combinacional : PROCESS(estadoPresente, start, finish,timer_15, timer_30)
	BEGIN
		 CASE estadoPresente IS
 ----------------------------------------------------------------
-- Estado IDLE
-- Semáforo parado/esperando iniciar
----------------------------------------------------------------
			WHEN idle		=>	led_red		<=	'0';
									led_green	<=	'0';
								IF start = '0' THEN
									estadoProximo	<=	vermelho;
								ELSE
									estadoProximo	<=	idle;
									END IF;
			WHEN vermelho	=>	led_red		<=	'1';
									led_green	<=	'0';
									IF    timer_30 = '1' and finish = '1' THEN
										estadoProximo	<=	verde;
									ELSIF timer_30 = '0' and finish = '1' THEN
										estadoProximo	<=	vermelho;
									ELSE
										estadoProximo	<=	idle;
									END IF;
			WHEN verde		=>	led_red		<=	'0';
									led_green	<=	'1';
									IF    timer_15 = '1' and finish = '1' THEN
										estadoProximo	<=	vermelho;
									ELSIF timer_15 = '0' and finish = '1' THEN
										estadoProximo	<=	verde;
									ELSE
										estadoProximo	<=	idle;
									END IF;
			WHEN OTHERS		=>	led_red			<=	'0';
									led_green		<=	'0';
												estadoProximo	<=	idle;
		END CASE;
	END PROCESS;
END ARCHITECTURE;
