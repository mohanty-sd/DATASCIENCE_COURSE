import numpy as np
import math

def F_cross(theta, phi):

    return np.cos(theta) * np.sin(2*phi)

def F_plus(theta, phi):

    return 0.5 * (1 + np.cos(theta) ** 2) * np.cos(2 * phi)
#####################################################################################
#完整的Fx+ ，用于对比
def F_plus3(theta, phi, psi):

    return 0.5 * (1 + np.cos(theta) **2) * np.cos(2*phi)*np.cos(2*psi) - np.cos(theta)*np.sin(2*phi)*np.sin(2*psi)

def F_cross3(theta, phi, psi):

    return 0.5 * (1 + np.cos(theta) **2) * np.cos(2*phi)*np.sin(2*psi) + np.cos(theta)*np.sin(2*phi)*np.cos(2*psi)


#####################################################################################
#这里修改角度和极化角psi. 极化角实际上用不到
theta = math.pi/2
phi = math.pi/2
psi = 0#math.pi/8

#####################################################################################
#张量语言计算F+x
# 定义向量和张量
nx = np.array([1, 0, 0])
ny = np.array([0, 1, 0])
Z = np.array([0,0,1])


x =np.sin(theta) * np.cos(phi)
y =np.sin(theta) * np.sin(phi)
z =np.cos(theta)
nhat = np.array([x,y,z])

xhat = np.cross(Z, nhat)
norm = np.linalg.norm(xhat)
xhat = xhat/norm

yhat = np.cross(xhat, nhat)


# 计算张量积
nxx = np.outer(nx, nx)
nyy = np.outer(ny, ny)

xx = np.outer(xhat, xhat)
yy = np.outer(yhat, yhat)

xy = np.outer(xhat, yhat)
yx = np.outer(yhat, xhat)
# 计算差和和
eplus = xx - yy
ecross = xy + yx

# 计算 Dect
Dect = (nxx - nyy) / 2

# 计算 Fplus 和 Fcross
Fplus = np.tensordot(Dect, eplus, axes=([0, 1], [0, 1]))
Fcross = np.tensordot(Dect, ecross, axes=([0, 1], [0, 1]))

# 打印结果
print("Fplus:")
print(Fplus)
print("Fcross:")
print(Fcross)
#####################################################################################
def h_sin(A, f, phi_0,t):

    return A * np.sin(2.0 * np.pi * f * t + phi_0)
#####################################################################################

t = np.arange(1., 2. , 0.01) #时间坐标，注意间隔需要满足Nyquist 定理

h_cross = h_sin(10., 10., 0. , t)
h_plus = h_sin(8.,10., math.pi/4 , t)

strain = F_cross(theta , phi)*h_cross + F_plus(theta , phi)*h_plus

#####################################################################################
import matplotlib.pyplot as plt
plt.plot(t, strain)
plt.xlabel('Time')
plt.ylabel('Strain')
plt.title('Strain vs Time')
plt.show()