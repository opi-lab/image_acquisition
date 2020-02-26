// starter code for real-time acquisition of a certain quantity of images through a camera GigE & USB 3.0.
​
#include <pylon/PylonIncludes.h> // library call that stores a range of methods for pylon.
#ifdef PYLON_WIN_BUILD
#	include <pylon/PylonGUI.h> // 
#endif
using namespace Pylon; // namespace with all the functions associated to the pylon scope.
static const uint32_t c_countOfImagesToGrab = 100; // quantity images that will be recorded.
int code = 0; char filename[88];
int main(int argc, char* argv[]) // main method (argument input enabled through the command line).
{
	PylonInitialize(); // before using any pylon methods, the pylon runtime must be initialized.
	try // try-catch structure used to handle exceptions within program due to unexpected errors.
	{
		IPylonDevice* pDevice = CTlFactory::GetInstance().CreateFirstDevice(); // create camera device.
		// create a instance camera object with the image acquisition device found first.
		CInstantCamera camera(CTlFactory::GetInstance().CreateFirstDevice());
		std::cout << "Device: " << camera.GetDeviceInfo().GetModelName() << std::endl;
		camera.MaxNumBuffer = 10; // control buffers allocated for grabbing, the default value is 10.
		// the camera device is configured by default to free-running continuous acquisition.
		camera.StartGrabbing(c_countOfImagesToGrab); // acquisition must be stopped upon reaching amount.
		CGrabResultPtr ptrGrabResult; // this smart pointer will receive the grab result data.
		// when requested images have been recovered, camera.StopGrabbing() is automatically called.
		while (camera.IsGrabbing())
		{
			// wait a specific time [ms] to recover image, and add controller exception.
			camera.RetrieveResult(5000, ptrGrabResult, TimeoutHandling_ThrowException);
			if (ptrGrabResult -> GrabSucceeded()) // image grabbed successfully?
			{
				const uint8_t *pImageBuffer = (uint8_t *)ptrGrabResult -> GetBuffer();
				std::cout << "gray value pixel[0]: " << (uint32_t)pImageBuffer[0] << std::endl << std::endl;
				Pylon::DisplayImage(1,ptrGrabResult); // display the grabbed image.
				// generate a unique identification for each photograph acquired in the interval.
				// code = static_cast <float> (rand()) / static_cast <float> (RAND_MAX);
				code = code + 1; strcat_s(filename, "grabbed_image");
				strcat_s(filename, std::to_string(code).c_str()); strcat_s(filename, ".png");
				CImagePersistence::Save(ImageFileFormat_Png,filename,ptrGrabResult);
				memset(filename, 0, 88); // clean container vector of names for stored images.
			}
			else
			{
				std::cout << "error: " << ptrGrabResult->GetErrorCode() << " " 
					<< ptrGrabResult-> GetErrorDescription() << std::endl;
			}
		}
	}
	catch(const GenericException & error_description)
	{	
		// the cerr method throws a message through the console indicating the reason for errors.
		std::cerr << "reason for failure ::: " << error_description.GetDescription() << std::endl;
	}
}
