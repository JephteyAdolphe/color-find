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
    def __init__(self, pic_path: str) -> None:
        try:
            self.__pic_path, self.__img = pic_path, Image.open(pic_path)
            self.__grayscale_img = None
            self.__grayscale_path = "grayscale_" + pic_path
        except FileNotFoundError:
            self.__img = self.__grayscale_img = None
            print("File not found")

    def convert_to_grayscale(self) -> None:
        # checks if we have a valid source image and edited image exists in current directory
        if self.__img and not os.path.isfile(self.__grayscale_path):
            self.__grayscale_img = self.__img.convert("LA")
            # self.__grayscale_img = self.__grayscale_img.convert("L")
            self.__grayscale_img.save(self.__grayscale_path)

    def convert_to_binary(self):
        pass

    def display_original_image(self) -> None:
        try:
            plt.imshow(self.__img)
            plt.show()
        except TypeError:
            print("No image to display")

    def display_edited_image(self) -> None:
        # displays edited image if one has already been created
        try:
            # self.convert_to_grayscale()   # creates modifiable image if it doesn't already exist
            plt.imshow(self.__grayscale_img)
            plt.show()
        except TypeError:
            print("No image to display")

    def get_original_image_object(self) -> object:
        return self.__img

    def get_edited_image_object(self) -> object:
        return self.__grayscale_img

    def resize(self, width: float, height: float) -> None:
        pass

    def get_original_num_array(self) -> np.ndarray:
        if self.__img:
            return np.array(self.__img)
        else:
            print("Image does not exist")

    def get_edited_num_array(self) -> np.ndarray:
        if self.__grayscale_img:
            return np.array(self.__grayscale_img)
        else:
            # self.convert_to_grayscale()   # creates modifiable image if it doesn't already exist
            print("Edited image does not exist")

    def get_original_dimensions(self) -> tuple:
        if self.__img:
            return np.array(self.__img).shape
        else:
            print("Image does not exist")

    def get_edited_dimensions(self) -> tuple:
        if self.__grayscale_img:
            return np.array(self.__grayscale_img).shape
        else:
            # self.convert_to_grayscale()   # creates modifiable image if it doesn't already exist
            print("Edited image does not exist")

    # so far only displays outer edge
    def display_edges(self):
        edge = self.__img.filter(ImageFilter.FIND_EDGES)
        plt.imshow(edge)
        plt.show()

    def delete_edited_image(self) -> None:
        try:
            os.remove(self.__grayscale_path)
            self.__grayscale_img = None
            print("Image deleted")
        except FileNotFoundError:
            print(f"Could not find the file {self.__grayscale_path} to delete")


test = Algorithm("dog.png")
test.display_original_image()
# if not os.path.isfile("test.txt"):
#     compressedArr = test.get_original_num_array()[:, :, 0]
#     np.savetxt("test.txt", compressedArr, fmt="%d", delimiter=",")

# look at text file
# compressedArr = test.get_original_num_array()[:, :, 0]
# plt.imshow(compressedArr)
# plt.show()
