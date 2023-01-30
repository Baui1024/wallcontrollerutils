#define PY_SSIZE_T_CLEAN
#include <Python.h>


static PyObject *convertImage(PyObject *self, PyObject *args) {
    PyObject *pixel_data_obj;
    int width;
    int height;
    int rotation;
    if (!PyArg_ParseTuple(args, "Oiii", &pixel_data_obj, &width, &height, &rotation)) {
        return NULL;
    }

    // Convert the pixel data to a char array
    char *pixel_data = PyBytes_AsString(pixel_data_obj);
    if (pixel_data == NULL) {
        return NULL;
    }

    // Rotate the image
    if (rotation % 90 != 0) {
        return PyErr_Format(PyExc_ValueError, "Invalid rotation value %d. Only 90-degree increments are allowed.", rotation);
    }

    int new_width, new_height;
    if (rotation % 180 == 90) {
        new_width = height;
        new_height = width;
    } else {
        new_width = width;
        new_height = height;
    }

    // Create a new bytearray to store the pixel data in RGB565 format
    int size = new_width * new_height * 2;
    char *rgb565_data = (char *)malloc(size);

    // Iterate over the pixels and pack them into 16-bit integers
    for (int y = 0; y < new_height; y++) {
        for (int x = 0; x < new_width; x++) {
            int old_x, old_y;
            switch (rotation % 360) {
                case 90:
                    old_x = y;
                    old_y = new_width - x - 1;
                    break;
                case 180:
                    old_x = new_width - x - 1;
                    old_y = new_height - y - 1;
                    break;
                case 270:
                    old_x = new_height - y - 1;
                    old_y = x;
                    break;
                default:
                    old_x = x;
                    old_y = y;
            }
            int old_index = (old_y * width + old_x) * 3;
            int r = pixel_data[old_index];
            int g = pixel_data[old_index + 1];
            int b = pixel_data[old_index + 2];
            int index = (y * new_width + x) * 2;

            unsigned short rgb565 = ((r >> 3) & 0x1f) << 11 | ((g >>2 ) & 0x3f) << 5 | ((b >> 3) & 0x1f);             
            //printf("%d,%d,%d___%d\n",r,g,b,rgb565);
            //rgb565_data[index] = rgb565 & 0xff;          
            //rgb565_data[index + 1] = rgb565 >> 8;
            rgb565_data[index] = rgb565 >> 8;
            rgb565_data[index + 1] = rgb565 & 0xff;
        }
    }

    PyObject *result = Py_BuildValue("y#", rgb565_data, size);

    free(rgb565_data);
    return result; 
}

static PyObject* version(PyObject* self)
{
    return Py_BuildValue("s", "Version 0.03");
};

static PyMethodDef Examples[] = {
    {"convertImage", convertImage, METH_VARARGS, "Calculates and prints all prime number between lower bound and upper bound provided by given range"},
    {"version", (PyCFunction)version, METH_NOARGS, "returns the version of the module"},
    {NULL, NULL, 0, NULL}
};

static struct PyModuleDef wallcontrollerutils = {
    PyModuleDef_HEAD_INIT,
    "wallcontrollerutils",
    "convertImage Module",
    -1, //global state
    Examples
};

//INITIALIZER FUNCTION
PyMODINIT_FUNC PyInit_wallcontrollerutils(void)
{
    return PyModule_Create(&wallcontrollerutils);
}
