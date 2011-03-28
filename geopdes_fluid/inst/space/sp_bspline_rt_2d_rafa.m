% SP_BSPLINE_RT_2D_PHYS: Construct the Raviart-Thomas pair of B-Splines spaces on the physical domain in 2D.
%
%     [spv, spp, [PI]] = sp_bspline_rt_2d_phys (knotsv, degreev, knotsp, degreep, msh)
%
% INPUTS:
%
%     knotsp:       b-spline knots of the pressure space along each parametric direction
%     degree:       b-spline degree of the pressure space along each parametric direction
%     msh:          structure containing the domain partition and the quadrature rule (see msh_push_forward_2d)
%
% OUTPUT:
%
%    spv: structure representing the discrete velocity function space
%    spp: structure representing the discrete pressure function space
%         each of the above has the following fields:
%    PI:  optionally compute a projector to remove one dof per corner from 
%         the pressure space. N.B. This option is currently only supported
%         for degree = [3 3];
%
%   For more details, see:
%      A.Buffa, C.de Falco, G. Sangalli, 
%      IsoGeometric Analysis: Stable elements for the 2D Stokes equation
%      IJNMF, 2010
%
% Copyright (C) 2009, 2010 Carlo de Falco
%
%    This program is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.

%    This program is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with this program.  If not, see <http://www.gnu.org/licenses/>.

function [spv, spp, PI] = sp_bspline_rt_2d_rafa (knotsv1, degreev1, ...
                                    knotsv2, degreev2, knotsp, degreep, msh)

spp = sp_bspline_2d_phys (knotsp, degreep, msh, 'gradient', false);
spv = do_spv__ (knotsv1, degreev1, knotsv2, degreev2, msh);
spv.spfun = @(MSH) do_spv__ (knotsv1, degreev1, knotsv2, degreev2, MSH);

PI = b2nst_odd__ (knotsp{1}, knotsp{2}, degreep(1), degreep(2), msh, spp);

end

function spv = do_spv__ (knotsv1, degreev1, knotsv2, degreev2, msh);
 spvx  = sp_bspline_2d_param (knotsv1, degreev1, msh);
 spvy  = sp_bspline_2d_param (knotsv2, degreev2, msh);
 spv   = sp_scalar_to_vector_2d (spvx, spvy, msh, 'divergence', true);
 spv   = sp_piola_transform_2d  (spv, msh);
end