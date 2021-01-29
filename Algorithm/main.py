import numpy as np
import matplotlib.pyplot as plt
import os
from PIL import Image, ImageFilter


class Algorithm:

    # initializes class variables / paths
    def __init__(self, path: str) -> None:
        try:
            self.__img = Image.open(path)
            self.__path = path
            if self.getDimensions()[0] > 1200 and self.getDimensions()[1] > 1200:
                self.__resize()

            self.idColorMap = None
            self.idArr = self.__getIDArray()
            self.__grayscaleImage = None
            self.__grayscalePath = "grayscale " + path

        except FileNotFoundError:
            self.__img = self.__grayscaleImage = None
            print("File not found")

    def convertToGrayscale(self) -> None:
        # checks if we have a valid source image and edited image exists in current directory
        if self.__img and not os.path.isfile(self.__grayscalePath):
            if ".png" in self.__grayscalePath:
                self.__grayscaleImage = self.__img.convert("LA")     # converts png image to grayscale
            else:
                self.__grayscaleImage = self.__img.convert("L")     # converts jpeg image to grayscale

            self.__grayscaleImage.save(self.__grayscalePath)

    def showImage(self) -> None:
        try:
            plt.imshow(self.__img)
            plt.show()
        except TypeError:
            print("No image to display")

    def showEditedImage(self) -> None:
        # displays edited image if one has already been created
        try:
            # self.convertToGrayscale()   # creates modifiable image if it doesn't already exist
            plt.imshow(self.__grayscaleImage)
            plt.show()
        except TypeError:
            print("No image to display")

    def __resize(self) -> None:
        self.__img = self.__img.resize((600, 600))

    # returns 2D array where each rgb pixel is represented by a string
    def getRGB(self) -> list:
        if self.__img:  # checks for valid image
            return self.__rgb(self.__img, self.getDimensions()[0], self.getDimensions()[1])
        else:
            print("Image does not exist")

    # returns 2D array where each rgb pixel is represented by a string
    def getEditedRGB(self) -> list:
        if self.__grayscaleImage:   # checks for valid image
            return self.__rgb(self.__grayscaleImage, self.getEditedDimensions()[0], self.getEditedDimensions()[1])
        else:
            # self.convertToGrayscale()   # creates modifiable image if it doesn't already exist
            print("Edited image does not exist")

    # RGB string array helper function
    def __rgb(self, image, x: int, y: int) -> list:
        rgbArr = []
        numArr = np.array(image)  # converts image object to numpy array

        for i in range(x):
            rgbArr.append([])
            for j in range(y):
                # iterates through pixel list and makes each value a string
                pixel = [str(rgb) for rgb in np.array(numArr[i][j]).tolist()]
                rgbArr[i].append(','.join(pixel))
        return rgbArr

    # return color ID array
    def __getIDArray(self) -> list:
        if self.__img:  # checks for valid image
            return self.__getID(self.__img, self.getDimensions()[0], self.getDimensions()[1])
        else:
            print("Image does not exist")

    # return color ID array for edited image
    def getEditedIDArray(self) -> list:
        if self.__grayscaleImage:   # checks for valid image
            return self.__getID(self.__grayscaleImage, self.getEditedDimensions()[0], self.getEditedDimensions()[1])
        else:
            # self.convertToGrayscale()   # creates modifiable image if it doesn't already exist
            print("Edited image does not exist")

    # returns 2D array where each rgb pixel is represented by an id number dictating which color block it belongs to
    def __getID(self, image, x: int, y: int) -> list:
        numArr = np.array(image)  # converts image object to numpy array
        idArr = []
        idMap = {
            # 0: [0, 0, 0, 0],  # jpeg is length 3 while png is length 4
            # 1: [0, 0, 0, 255],  # outline of image (for black solid outline though)
        }

        for i in range(x):
            idArr.append([])
            for j in range(y):
                pixel = np.array(numArr[i][j]).tolist()

                if list(idMap):
                    if self.__getIDHelper(idMap, pixel) is not None:
                        idArr[i].append(self.__getIDHelper(idMap, pixel))
                    else:
                        # new color has been visited -> create new ID
                        newID = list(idMap)[-1] + 1
                        idMap[newID] = pixel
                        idArr[i].append(newID)
                else:
                    idMap[0] = pixel
                    idArr[i].append(0)

        self.idColorMap = idMap
        return idArr

    # gets ID for visited pixel
    def __getIDHelper(self, idMap: dict, pixelToCheck: list) -> int:
        for colorID in idMap:
            matches = 0
            for i in range(len(pixelToCheck)):
                # checks to see if any rgb value pairs differ by 20 or more
                if abs(pixelToCheck[i] - idMap[colorID][i]) < 60:
                    matches += 1
            if matches == len(pixelToCheck):
                return colorID
        return None

    def getDimensions(self) -> tuple:
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
    def showOutline(self) -> None:
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

    def saveToTxt(self) -> None:
        txtFile = self.__path.split(".")[0] + ".txt"
        if not os.path.isfile(txtFile):
            np.savetxt(txtFile, np.array(self.idToRGB()), fmt="%d", delimiter=",")

    # convert id array back to image object readable by pillow
    def idToRGB(self) -> np.ndarray:
        convertedID = []
        idArr = self.getIDArray()
        for i in range(len(idArr)):
            convertedID.append([])
            for j in range(len(idArr[i])):
                convertedID[i].append(self.idColorMap[idArr[i][j]])
        return np.array(convertedID)

    # returns color has map with color ID and their corresponding pixel(rgb) list
    def getColorMap(self) -> dict:
        return self.idColorMap


ball = Algorithm("dog.png")
# print(ball.saveToTxt())
# imageIdToRGB = ball.idToRGB()
# plt.imshow(imageIdToRGB)
# plt.show()
