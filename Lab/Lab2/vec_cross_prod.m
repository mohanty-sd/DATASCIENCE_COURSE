function c_vec = vec_cross_prod(a_vector, b_vector)

[nsize, ~]= size(a_vector);
c_vec = zeros(nsize, 3);
c_vec(:,1) = a_vector(:,2).*b_vector(:,3) - a_vector(:,3).*b_vector(:,2);
c_vec(:,2) = a_vector(:,3).*b_vector(:,1) - a_vector(:,1).*b_vector(:,3);
c_vec(:,3) = a_vector(:,1).*b_vector(:,2) - a_vector(:,2).*b_vector(:,1);

end