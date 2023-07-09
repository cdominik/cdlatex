;;; electricindex.el --- Fast digit index insertion -*- lexical-binding: t; -*-
;; Copyright (c) 2022  Free Software Foundation, Inc.
;;
;; Author: Carsten Dominik <carsten.dominik@gmail.com>
;; Keywords: tex
;; Version: 1.0
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
;; Electricindex is a minor mode supporting fast digit index insertation in
;; LaTeX math. For example typing  x 1 2  will insert x_{12}. It is an
;; independent minor mode that is distributed with the cdlatex package.
;;
;; To turn Electricindex Minor Mode on and off in a particular buffer, use
;; `M-x electricindex-mode'.
;;
;; To turn on Electricindex Minor Mode for all LaTeX files, add one of the
;; following lines to your .emacs file:
;;
;;   (add-hook 'latex-mode-hook #'turn-on-electricindex)
;;
;; This index insertion will only work when the cursor is in a LaTeX math
;; environment, based on (texmathp). If texmathp is not available, math
;; math-mode will be assumed.
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
  :link '(url-link :tag "Home Page" "https://github.com/cdominik/cdlatex")
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
  :lighter " EI")

(defun electricindex-active-here ()
  (if (eq major-mode 'latex-mode)
      (if (fboundp 'texmathp)
          (texmathp)
        t)
    t))

;;; ===========================================================================
;;;

(defun electricindex-digit ()
  "Insert digit, maybe as an index to a quantity in math environment."
  (interactive)
  (if (not (electricindex-active-here))
      (self-insert-command 1)
    (let ((digit (char-to-string (event-basic-type last-command-event))))
      (if (looking-back "[a-zA-Z]" (1- (point)))
          (insert "_" digit " ")
        (if (looking-back "\\(_[0-9]\\) ?" (- (point) 3))
            (progn
              (goto-char (match-beginning 1))
              (forward-char 1)
              (insert "{")
              (forward-char 1)
              (insert digit "}")
              (if (looking-at " ")
                  (forward-char 1)
                (insert " ")))
          (if (looking-back "_{\\([0-9]+\\)} ?" (max (- (point) 10) (point-min)))
              (save-excursion
                (goto-char (match-end 1))
                (insert digit))
            (self-insert-command 1)))))))

(provide 'electricindex)

;;;============================================================================

;;; electricindex.el ends here
