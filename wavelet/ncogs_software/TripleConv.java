import java.util.List;
import java.util.ArrayList;
import org.trifort.rootbeer.runtime.Kernel;
import org.trifort.rootbeer.runtime.Rootbeer;
import org.trifort.rootbeer.runtime.util.Stopwatch;

public class TripleConv {

	public double[][][] convolve(double[][][] image,  double[][][] kernel1,
			double[][][] kernel2, double[][][] kernel3) {
		
		image = convolveReal(convolveReal(convolveReal(image, kernel1), kernel2), kernel3);
		
		return image;
		
	}
	
	
	private double[][][] convolveReal(double[][][] image, double[][][] kernel) {
		
		int imageHeight = image.length;
		int imageWidth = image[0].length;
		int imageDepth = image[0][0].length;
		
		int kernelHeight = kernel.length;
		int kernelWidth = kernel[0].length;
		int kernelDepth = kernel[0][0].length;
		
		int halfHeight = (int)( (kernelHeight - 1) / 2.0);
		int halfWidth = (int)( (kernelWidth - 1) / 2.0 );
		int halfDepth = (int)( (kernelDepth - 1) / 2.0 );
		
		double sum;
		
		double[][][] result = new double[imageHeight][imageWidth][imageDepth];
		
		for (int i = halfHeight; i < imageHeight-halfHeight; i++) {
			for (int j = halfWidth; j < imageWidth-halfWidth; j++) {
				for (int k = halfDepth; k < imageDepth-halfDepth; k++) {
					
					sum = 0;
					
					for (int m = 0; m < kernelHeight; m++) {
						for (int n = 0; n < kernelWidth; n++) {
							for (int p = 0; p < kernelDepth; p++) {
								
								int adjI = i + (m-halfHeight);
								int adjJ = j + (n-halfWidth);
								int adjK = k + (p-halfDepth);
								
								sum += image[adjI][adjJ][adjK] * kernel[m][n][p];
								
							}
						}
					}
					
					result[i-halfHeight][j-halfWidth][k-halfDepth] = sum;
							
					
				}
			}
		}
		
		return result;
		
	}
	
}
