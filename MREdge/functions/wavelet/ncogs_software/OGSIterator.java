




public class OGSIterator {
	
	public OGSIterator() {}
	
	double a;
	
	
	
	public double[][][] iterate(int Nit, double[][][] h1, double[][][] h2, double[][][] h3, 
			double[][][] x, double[][][] y,	double lam, double a) {
	
		this.a = a;
		
		TripleConv TC = new TripleConv();
		
		double[] cost = new double[Nit];
		
		for (int it = 0; it < Nit; it++) {
			    double[][][] r = sqrt(  TC.convolve( square(abs(x) ), h1, h2, h3 )  );
			    cost[it] = 0.5 * sum(  addScalar( square (abs(subtract(x, y))) , 
			    		lam * sum(phi(r)) )  );
			    double[][][] v = addScalar(
			    		multiplyScalar(TC.convolve(recip(wfun(r)), h1, h2, h3), lam),
			    		1);
			    x = divide(y, v);
		
		}
		
		return x;
	
	}


	//phi = @(x) 2/(a*sqrt(3)) *  (atan( ( 1+2*a*abs(x) )/sqrt(3)) - pi/6);
	//wfun = @(x) abs(x) .* (1 + a*abs(x) + a^2.*abs(x).^2);

	private double[][][] phi(double[][][] x) {
		
		double[][][] res = 
			multiplyScalar(  
				subtractScalar (
					atan(   
						divideScalar(  
							addScalar( 
								multiplyScalar( abs(x), 
									2*a ), 
								1 ), 
							Math.sqrt(3) )
						),
					(Math.PI - 6) ), 
				( 2 / ( a*Math.sqrt(3) ) ) 
			);
				
		return res;
	}
	
	private double[][][] wfun(double[][][] x){
	
		double[][][] res = 
				multiply(
					add(
						addScalar(
							multiplyScalar(abs(x),
								a),
							1),
						multiplyScalar(square(abs(x)),
							a*a)
						),
					abs(x)
					);
		
		return res;
	
	}
	
	
	
	private double[][][] add(double[][][] x, double[][][] y) {
		int height = x.length;
		int width = x[0].length;
		int depth = x[0][0].length;
		
		for (int i = 0; i < height; i++) {
			for (int j = 0; j < width; j++) {
				for (int k = 0; k < depth; k++) {
					
					x[i][j][k] = x[i][j][k] + y[i][j][k];
				}
			}
		}
		
		return x;
		
	}
	
	private double[][][] addScalar(double[][][] x, double y) {
		int height = x.length;
		int width = x[0].length;
		int depth = x[0][0].length;
		
		for (int i = 0; i < height; i++) {
			for (int j = 0; j < width; j++) {
				for (int k = 0; k < depth; k++) {
					
					x[i][j][k] = x[i][j][k] + y;
				}
			}
		}
		
		return x;
		
	}
	
	private double[][][] subtract(double[][][] x, double[][][] y) {
		int height = x.length;
		int width = x[0].length;
		int depth = x[0][0].length;
		
		for (int i = 0; i < height; i++) {
			for (int j = 0; j < width; j++) {
				for (int k = 0; k < depth; k++) {
					
					x[i][j][k] = x[i][j][k] - y[i][j][k];
				}
			}
		}
		
		return x;
		
	}
	
	private double[][][] subtractScalar(double[][][] x, double y) {
		int height = x.length;
		int width = x[0].length;
		int depth = x[0][0].length;
		
		for (int i = 0; i < height; i++) {
			for (int j = 0; j < width; j++) {
				for (int k = 0; k < depth; k++) {
					
					x[i][j][k] = x[i][j][k] - y;
				}
			}
		}
		
		return x;
		
	}
	
	private double[][][] multiply(double[][][] x, double[][][] y) {
		int height = x.length;
		int width = x[0].length;
		int depth = x[0][0].length;
		
		for (int i = 0; i < height; i++) {
			for (int j = 0; j < width; j++) {
				for (int k = 0; k < depth; k++) {
					
					x[i][j][k] = x[i][j][k] * y[i][j][k];
				}
			}
		}
		
		return x;
		
	}
	
	private double[][][] multiplyScalar(double[][][] x, double y) {
		int height = x.length;
		int width = x[0].length;
		int depth = x[0][0].length;
		
		for (int i = 0; i < height; i++) {
			for (int j = 0; j < width; j++) {
				for (int k = 0; k < depth; k++) {
					
					x[i][j][k] = x[i][j][k] * y;
				}
			}
		}
		
		return x;
		
	}
	
	private double[][][] divide(double[][][] x, double[][][] y) {
		int height = x.length;
		int width = x[0].length;
		int depth = x[0][0].length;
		
		for (int i = 0; i < height; i++) {
			for (int j = 0; j < width; j++) {
				for (int k = 0; k < depth; k++) {
					
					x[i][j][k] = x[i][j][k] / y[i][j][k];
				}
			}
		}
		
		return x;
		
	}
	
	private double[][][] divideScalar(double[][][] x, double y) {
		int height = x.length;
		int width = x[0].length;
		int depth = x[0][0].length;
		
		for (int i = 0; i < height; i++) {
			for (int j = 0; j < width; j++) {
				for (int k = 0; k < depth; k++) {
					
					x[i][j][k] = x[i][j][k] / y;
				}
			}
		}
		
		return x;
		
	}
	
	private double[][][] recip(double[][][] x) {
		int height = x.length;
		int width = x[0].length;
		int depth = x[0][0].length;
		
		for (int i = 0; i < height; i++) {
			for (int j = 0; j < width; j++) {
				for (int k = 0; k < depth; k++) {
					
					x[i][j][k] = 1.0 / x[i][j][k];
				}
			}
		}
		
		return x;
		
	}
	
	private double[][][] square(double[][][] x) {
		int height = x.length;
		int width = x[0].length;
		int depth = x[0][0].length;
		
		for (int i = 0; i < height; i++) {
			for (int j = 0; j < width; j++) {
				for (int k = 0; k < depth; k++) {
					
					x[i][j][k] = x[i][j][k]*x[i][j][k];
				}
			}
		}
		
		return x;
		
	}
	
	private double[][][] sqrt(double[][][] x) {
		int height = x.length;
		int width = x[0].length;
		int depth = x[0][0].length;
		
		for (int i = 0; i < height; i++) {
			for (int j = 0; j < width; j++) {
				for (int k = 0; k < depth; k++) {
					
					x[i][j][k] = Math.sqrt(x[i][j][k]);
				}
			}
		}
		
		return x;
		
	}
	
	private double[][][] abs(double[][][] x) {
		int height = x.length;
		int width = x[0].length;
		int depth = x[0][0].length;
		
		for (int i = 0; i < height; i++) {
			for (int j = 0; j < width; j++) {
				for (int k = 0; k < depth; k++) {
					
					x[i][j][k] = Math.abs(x[i][j][k]);
				}
			}
		}
		
		return x;
		
	}
	
	private double[][][] atan(double[][][] x) {
		int height = x.length;
		int width = x[0].length;
		int depth = x[0][0].length;
		
		for (int i = 0; i < height; i++) {
			for (int j = 0; j < width; j++) {
				for (int k = 0; k < depth; k++) {
					
					x[i][j][k] = Math.atan(x[i][j][k]);
				}
			}
		}
		
		return x;
		
	}
	
	private double sum(double[][][] x) {
		int height = x.length;
		int width = x[0].length;
		int depth = x[0][0].length;
		
		double sum = 0;
		
		for (int i = 0; i < height; i++) {
			for (int j = 0; j < width; j++) {
				for (int k = 0; k < depth; k++) {
					
					sum += x[i][j][k];
				}
			}
		}
		
		return sum;
		
	}
	
}
