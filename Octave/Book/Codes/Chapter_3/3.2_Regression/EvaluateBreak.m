function sigma = EvaluateBreak (x_c, dist, force)
  M = ones (length (dist), 3);
  M (:, 2) = dist (:);
  M (:, 3) = max (0, dist (:) - x_c);
  [p, sigma] = LinearRegression (M, force (:));
  sigma = mean (sigma);
end%function

