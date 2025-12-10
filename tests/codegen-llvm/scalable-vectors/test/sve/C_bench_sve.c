#include <arm_sve.h> 
  
void saxpy_sve(float32_t *x, float32_t *y, float32_t a, uint32_t n) { 
        uint32_t i; 
   
        // define predicate and 'live' segments of x/y 
        svbool_t predicate; 
        svfloat32_t xseg; 
        svfloat32_t yseg; 
   
        // get the vector length being used, so we know how to increment the loop (1) 
        uint64_t numVals = svlen_f32(xseg); 
   
        for (i=0; i<n; i+=numVals) { // (2) 
                // set predicate based off loop counter (3) 
                predicate = svwhilelt_b32_s32(i, n); 
                  
                // load in a vectors worth of x and y values (4) 
                xseg = svld1_f32(predicate, x+i); // ld1w for x 
                yseg = svld1_f32(predicate, y+i); // ld1w for y 
   
                // perform the a*x[i] + y[i] operation in one go with MLA (5) 
                yseg = svmla_n_f32_m(predicate, yseg, xseg, a);  // y+a*x 
   
                // store yvalues (6) 
                svst1_f32(predicate, y+i, yseg); // st1w for y <-y+a*x 
        } 
} 