function sigVec = crsin(timeVec, A, f0, c0)
    % timeVec: ʱ����������ʾ�źŵ�ʱ����
    % A: ���
    % f0: ��ʼƵ��
    % c0: ��ʼ��λ

    % ���������ź�
    sigVec = A * sin(2 * pi * f0 * timeVec + c0);
end