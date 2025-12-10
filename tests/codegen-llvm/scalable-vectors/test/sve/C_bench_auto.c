#include <arm_sve.h> 
  
void saxpy_c(float32_t *x, float32_t *y, float32_t a, uint32_t n) { 
        // scaled vector add: y = a*x + y 
        int i; 
        for (i=0; i<n; i++) { 
                y[i] = a*x[i] + y[i]; 
        } 
}