#include "gd32e10x.h"

volatile uint32_t tickcnt=0;

void delayms(uint32_t t)
{
	tickcnt=t*10;
	while(tickcnt);
}

void SysTick_Handler(void)
{
	if(tickcnt) tickcnt--;
}

uint8_t uart_getchar(void) {return 0;}

void uart_putchar(uint8_t c)
{
	usart_data_transmit(USART1, c);
	while(usart_flag_get(USART1, USART_FLAG_TBE)==RESET);
}

void main(void)
{
	//108MHz internal RC
	SystemInit();

	SysTick_Config(SystemCoreClock/10000);
	NVIC_SetPriority(SysTick_IRQn, 0x00);

    /* enable the LED2 GPIO clock */
    rcu_periph_clock_enable(RCU_GPIOA);
    /* configure LED2 GPIO port */ 
    gpio_init(GPIOA, GPIO_MODE_OUT_PP, GPIO_OSPEED_50MHZ,GPIO_PIN_6);
	gpio_init(GPIOA, GPIO_MODE_OUT_PP, GPIO_OSPEED_50MHZ,GPIO_PIN_5);
    /* reset LED2 GPIO pin */
    gpio_bit_reset(GPIOA,GPIO_PIN_6);
	gpio_bit_reset(GPIOA,GPIO_PIN_5);

	float a=0.1f;

    while(1){

		gpio_bit_reset(GPIOA,GPIO_PIN_6);
		gpio_bit_reset(GPIOA,GPIO_PIN_5);
		for(int i = 10000;i>0;i--)a *=0.998f;		
        gpio_bit_set(GPIOA,GPIO_PIN_6);
		gpio_bit_set(GPIOA,GPIO_PIN_5);
		delayms(5);
    }
}
