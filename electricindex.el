;;; electricindex.el --- Fast input methods for LaTeX environments and math  -*- lexical-binding: t; -*-
;; Copyright (c) 2010-2022  Free Software Foundation, Inc.
;;
;; Author: Carsten Dominik <carsten.dominik@gmail.com>
;; Keywords: tex
;; Version: 4.14
;;
;; This file is not part of GNU Emacs.
;;
;; This file is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; electricindex.el is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with electricindex.el. If not, see <http://www.gnu.org/licenses/>.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;; Commentary:
;;
;; Electricindex is a minor mode supporting fast insertion of environment
;; templates and math stuff in LaTeX.
;;
;; To turn Electricindex Minor Mode on and off in a particular buffer, use
;; `M-x electricindex-mode'.
;;
;; To turn on Electricindex Minor Mode for all LaTeX files, add one of the
;; following lines to your .emacs file:
;;
;;   (add-hook 'LaTeX-mode-hook #'turn-on-electricindex)   ; with AUCTeX LaTeX mode
;;   (add-hook 'latex-mode-hook #'turn-on-electricindex)   ; with Emacs latex mode
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;;;;;

;;; Code:

;;; Begin of Configuration Section ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Configuration Variables and User Options for Electricindex ------------------

(defgroup electricindex nil
  "LaTeX label and citation support."
  :tag "Electricindex"
  :link '(url-link :tag "Home Page" "http://zon.astro.uva.nl/~dominik/Tools/")
  :prefix "electricindex-"
  :group 'tex)

;;;============================================================================
;;;
;;; Define the formal stuff for a minor mode named Electricindex.
;;;

(defvar electricindex-mode nil
  "Determines if Electricindex minor mode is active.")
(make-variable-buffer-local 'electricindex-mode)

(defvar electricindex-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map  "1"        #'electricindex-digit)
    (define-key map  "2"        #'electricindex-digit)
    (define-key map  "3"        #'electricindex-digit)
    (define-key map  "4"        #'electricindex-digit)
    (define-key map  "5"        #'electricindex-digit)
    (define-key map  "6"        #'electricindex-digit)
    (define-key map  "7"        #'electricindex-digit)
    (define-key map  "8"        #'electricindex-digit)
    (define-key map  "9"        #'electricindex-digit)
    (define-key map  "0"        #'electricindex-digit)
    map)
  "Keymap for Electricindex minor mode.")

;;;###autoload
(defun turn-on-electricindex ()
  "Turn on Electricindex minor mode."
  (electricindex-mode t))

;;;###autoload
(define-minor-mode electricindex-mode
  "Minor mode for electric insertion of numbered indixes.

Here is a list of features: \\<electricindex-mode-map>

Entering `electricindex-mode' calls the hook electricindex-mode-hook."
  :lighter " EI"
  (when electricindex-mode
    (electricindex-compute-tables)))

(defalias 'electricindex--texmathp
  (if (fboundp 'texmathp) #'texmathp
    ;; FIXME: Maybe we could do better, but why bother: the users who want it
    ;; can install AUCTeX.  Tho maybe we should move texmathp into its
    ;; own package so it can be used even when AUCTeX is not
    ;; installed/activated.
    #'ignore))

;;; ===========================================================================
;;;
;;; Functions that check out the surroundings

(provide 'electricindex)

;;;============================================================================

;;; electricindex.el ends here
