import numpy as np
import matplotlib.pyplot as plt
import os
from PIL import Image, ImageFilter

"""
- Maybe export num array to csv file when finished?

- backtracking algo to find dead end

- Need to compress the 3D array for that ^^^

- Resize picture in app framework since screen size of phone / tablet will
vary (find way to get screen size in app in order to accurately resize picture)?
"""


class Algorithm:

    # initializes class attributes / paths
    def __init__(self, path: str) -> None:
        try:
            self.__picPath, self.__img = path, Image.open(path)
            self.__grayscaleImage = None
            self.__grayscalePath = "grayscale " + path
        except FileNotFoundError:
            self.__img = self.__grayscaleImage = None
            print("File not found")

    def convertToGrayscale(self) -> None:
        # checks if we have a valid source image and edited image exists in current directory
        if self.__img and not os.path.isfile(self.__grayscalePath):
            self.__grayscaleImage = self.__img.convert("LA")
            # self.__grayscaleImage = self.__grayscaleImage.convert("L")
            self.__grayscaleImage.save(self.__grayscalePath)

    def convertToBinary(self):
        pass

    def displayOriginalImage(self) -> None:
        try:
            plt.imshow(self.__img)
            plt.show()
        except TypeError:
            print("No image to display")

    def displayEditedImage(self) -> None:
        # displays edited image if one has already been created
        try:
            # self.convertToGrayscale()   # creates modifiable image if it doesn't already exist
            plt.imshow(self.__grayscaleImage)
            plt.show()
        except TypeError:
            print("No image to display")

    # def getOriginalObject(self) -> object:
    #     return self.__img
    # 
    # def getEditedObject(self) -> object:
    #     return self.__grayscaleImage

    def resize(self, width: float, height: float) -> None:
        pass

    # returns 2D array where each rgb pixel is represented by a string
    def getOriginalRGB(self) -> list:
        if self.__img:  # checks for valid image
            rgbArr = []
            numArr = np.array(self.__img)   # convert imgage object to numpy array

            for i in range(self.getOriginalDimensions()[0]):
                rgbArr.append([])
                for j in range(self.getOriginalDimensions()[1]):

                    pixel = np.array(numArr[i][j]).tolist()
                    for k in range(len(pixel)):
                        pixel[k] = str(pixel[k])
                    pixelString = ','.join(pixel)

                    rgbArr[i].append(pixelString)
            return rgbArr
        else:
            print("Image does not exist")

    # returns 2D array where each rgb pixel is represented by a string
    def getEditedRGB(self) -> np.ndarray:
        if self.__grayscaleImage:
            return np.array(self.__grayscaleImage)
        else:
            # self.convertToGrayscale()   # creates modifiable image if it doesn't already exist
            print("Edited image does not exist")

    def getOriginalDimensions(self) -> tuple:
        if self.__img:
            return np.array(self.__img).shape
        else:
            print("Image does not exist")

    def getEditedDimensions(self) -> tuple:
        if self.__grayscaleImage:
            return np.array(self.__grayscaleImage).shape
        else:
            # self.convertToGrayscale()   # creates modifiable image if it doesn't already exist
            print("Edited image does not exist")

    # so far only displays outer edge
    def displayOutline(self):
        edge = self.__img.filter(ImageFilter.FIND_EDGES)
        plt.imshow(edge)
        plt.show()

    def deleteEditedImage(self) -> None:
        try:
            os.remove(self.__grayscalePath)
            self.__grayscaleImage = None
            print("Image deleted")
        except FileNotFoundError:
            print(f"Could not find the file {self.__grayscalePath} to delete")


test = Algorithm("dog.png")
print(test.getOriginalRGB())

# if not os.path.isfile("test.txt"):
#     compressedArr = test.get_original_num_array()[:, :, 0]
#     np.savetxt("test.txt", compressedArr, fmt="%d", delimiter=",")

# look at text file
# compressedArr = test.get_original_num_array()[:, :, 0]
# plt.imshow(compressedArr)
# plt.show()
